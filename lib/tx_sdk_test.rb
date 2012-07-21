#encoding: utf-8
require File.expand_path("../tx_sdk_exec",__FILE__);

#测试的QQ号码: 1759055604 | 密码: railsqq 请不要修改密码

open = OpenQQ.new(100645471,'e42a082e2052bd564b1d60900078c116','rails')
open.pf = "qzone"

# 测试的时候需要更新 openid 和 openkey 每次登录后都会有变化
# 可以在 http://opensns.qq.com/apps/tools 这里得到你的 QQ 的 openid 和 openkey
# 使用firbug就可以直接找到应用的openid和openkey
# http://qzone.devapp.open.qq.com/cgi-bin/devapp?qz_height=1000&qz_width=760&openid=00000000000000000000000097927FDC&openkey=D0AD261E00034F78641F3DF6AEC12E40&pf=qzone&pfkey=2307774e38c3ad9ee340d8eacdfb4cd3&qz_ver=6&appcanvas=1&params=&via=QZ.HashRefresh
openid = '915EA331A17C0B3FE83131128AD7D1A4'
openkey = 'B1B1305E2268FA304769472B70BBABBC'

# puts open.get_user_info(openid,openkey).inspect

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





















