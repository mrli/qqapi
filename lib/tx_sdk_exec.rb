# coding: utf-8  
require File.expand_path("../tx_sdk_const_defined",__FILE__);
require File.expand_path("../tx_sdk_interface",__FILE__);

class OpenQQ

  #引入接口库
  include QQApi

  #变量定义
  attr_accessor :server_name,  # server_name: 119.147.19.43 | 正式环境: openapi.tencentyun.com
                :app_key,      #应用的密钥用于验证应用的合法性
                :app_id,       #应用的唯一ID
                :app_name,     #应用的英文名(唯一)
                :pf            #应用平台 

  # 构造函数
  def initialize(appid,appkey,appname)
    @server_name = '119.147.19.43'
    @appid = appid
    @appkey = appkey
    @appname = appname
    @pf = "qzone"
    @format = "json"
  end

  #验证openid是否合法
  
  def self.is_open_id?(open_id)
    return true if /^[0-9a-fA-F]{32}$/.match(open_id)
    false
  end
  
  def api(interface_path, options = {})
    new_options = {}
    #检查参数的合法性
    check_params options
    #options[:appid] = @app_id

    # 像v3/usr/get_info 类型接口
    api_interface = interface_path

    #取出传过来的参数这些参数用于生成密钥
    gen_sig_options={
      "openid"=>options["openid"],
      "openkey"=>options["openkey"],      
      "appid"=>@appid,
      "pf"=>@pf
    }
    # binding.pry

    options.delete("openid")
    options.delete("openkey")
    # gen_sig_options.delete("pf")


    # binding.pry
    
    #生成密匙
    sig_str = get_sig(api_interface,gen_sig_options)

    gen_sig_options.delete("pf")
    gen_sig_options["sig"] = sig_str
    gen_sig_options["pf"] = @pf

    new_options = gen_sig_options.merge options
    # binding.pry
    #组合请求地址
    result = make_request(api_interface,new_options)
    # binding.pry
    #构成需要的URl
    return result
  end

  #检查参数的合法性
  def check_params(options={})
    if options["openid"].nil? or options["openid"] == ''
      return {:ret => PYO_ERROR_REQUIRED_PARAMETER_EMPTY, :msg => 'openid 为空'}
    else
       unless OpenQQ.is_open_id?(options["openid"])
         return {:ret => PYO_ERROR_REQUIRED_PARAMETER_INVALID, :msg => 'openid 不合法'}
      end
    end

    if options["openkey"].nil? or options["openkey"] == ''
      return {:ret => PYO_ERROR_REQUIRED_PARAMETER_EMPTY, :msg => 'openkey 为空'}
    end 
  end

  private 
    #参考: http://wiki.open.qq.com/wiki/腾讯开放平台第三方应用签名参数sig的说明
    def get_sig(api_interface,options={},http_m="POST")

      ###########################Step 2. 源串构造###########################
      #对参数进行字典排序,以便后面使用      
      query_params = options.sort.collect { |v| v.join("=")}.join("&")
      
      #第1步
      http_method = "#{http_m}&";
      
      #第2步
      http_interface = api_interface.to_uri+"&"; # %2Fv3%2Fuser%2Fget_info&

      #第3步
      #appid%3D100641389%26openid%3DAF985DBE4C198FD5587A95B1A52D64E1%26openkey%3DBD933219F4EE9C2134827E61C0EACDF8%26pf%3Dqzone
      params = query_params.to_uri
      
      #将HTTP请求方式，第1步以及第3步中的到的字符串用&拼接起来，得到源串：
      #POST&%2Fv3%2Fuser%2Fget_info&appid%3D100641389%26openid%3DAF985DBE4C198FD5587A95B1A52D64E1%26openkey%3DBD933219F4EE9C2134827E61C0EACDF8%26pf%3Dqzone 
      path = "#{http_method}#{http_interface}#{params}"
     
      #Step 2.构造密钥
      appkey = "#{@appkey}&"

      ###########################Step 3. 生成签名值###########################  
      # SHA1 加密
      tmp_str = Digest::HMAC.digest(path, appkey, Digest::SHA1)

      #base64编码
      sig_str = Base64.encode64(tmp_str).gsub("\n","")#.gsub("+","%20") #X2/7qhS1yZ7m3joN76VuskDlJDk=
      
      # binding.pry
      return sig_str
    end

    # 执行一个 HTTP POST 请求, 返回结果数组。可能发生cURL错误
    # 参数:
    #   - path : 执行请求的路径
    #   - options : 表单参数
    def make_request(path,options = {})
      #类似于:
      #<Net::HTTP 119.147.19.43:80 open=false>
      http = Net::HTTP.new @server_name
      
      #重组路径
      _path = options.collect { |v| v.join("=") }.join("&")

      #构造appkey
      req = http.request_post(path,_path)
      
      # binding.pry
      # 远程返回的不是 json 格式, 说明返回包有问题
      result_json = JSON.parse(req.body)

      if result_json == {}
        return {:ret => PYO_ERROR_RESPONSE_DATA_INVALID, :msg => result}
      end  
      return result_json
    end
end


open = OpenQQ.new(100645471,'e42a082e2052bd564b1d60900078c116','rails')
open.pf = "qzone"


# 测试的时候需要更新 openid 和 openkey 每次登录后都会有变化
# 可以在 http://opensns.qq.com/apps/tools 这里得到你的 QQ 的 openid 和 openkey
# 使用firbug就可以直接找到应用的openid和openkey
# http://qzone.devapp.open.qq.com/cgi-bin/devapp?qz_height=1000&qz_width=760&openid=00000000000000000000000097927FDC&openkey=D0AD261E00034F78641F3DF6AEC12E40&pf=qzone&pfkey=2307774e38c3ad9ee340d8eacdfb4cd3&qz_ver=6&appcanvas=1&params=&via=QZ.HashRefresh
openid = '915EA331A17C0B3FE83131128AD7D1A4'
openkey = 'B1B1305E2268FA304769472B70BBABBC'

# puts open.get_user_info(openid,openkey).inspect
# binding.pry
#{"ret"=>0, "is_lost"=>0, "nickname"=>"mile", "gender"=>"女", "country"=>"中国", "province"=>"北京", "city"=>"朝阳", "figureurl"=>"http://thirdapp1.qlogo.cn/qzopenapp/0843a96cac25a31055f3a80984866325ae2b85125dd126e6d802ff383ed6724e/50", "is_yellow_vip"=>0, "is_yellow_year_vip"=>0, "yellow_vip_level"=>0, "is_yellow_high_vip"=>0}


# puts open.total_vip_info(openid,openkey).inspect

# puts open.is_setuped?(openid,openkey).inspect
#{"ret"=>0, "is_lost"=>0, "setuped"=>1}

# puts open.is_vip?(openid,openkey).inspect
#{"ret"=>0, "is_lost"=>0, "is_yellow_vip"=>0, "is_yellow_year_vip"=>0, "yellow_vip_level"=>0, "is_yellow_high_vip"=>0}

# puts open.is_login?(openid,openkey).inspect
#{"ret"=>0, "msg"=>"user is logged in"}

# puts open.get_app_friends(openid,openkey)
# # {"ret"=>0, "is_lost"=>0, "items"=>[{"openid"=>"FEC0BCCE7D4414481D0EF969B516E62D"}, {"openid"=>"DB2673263DF01D1C2BB183269051C8F4"}, {"openid"=>"0A3C349FB613F238992129E8958CF02F"}]}

# items = open.get_app_friends(openid,openkey)["items"]
# puts items
# fopend_id_arr = items.map{|ele| ele["openid"]}
# # binding.pry
# puts open.get_multi_info(openid, openkey, fopend_id_arr).inspect


# frends = open.get_app_friends(openid,openkey)["items"].first["openid"]
# puts open.is_friend?(frends,openid,openkey).inspect
#{"ret"=>0, "is_lost"=>0, "is_friend"=>1}

# puts open.captcha_get(openid,openkey).inspect
#二进制流图片

# puts open.check_spam("1","hello",openid,openkey).inspect
#{"ret"=>0, "is_lost"=>0, "result"=>0, "forbidden_time"=>0}





















