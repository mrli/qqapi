#encoding: utf-8
#封装了腾讯官方的接口,只是部分,还有其它的没有做,希望你可以贡献力量 
module QQApi

	#******************************* 平台基础功能类接口 *****************************

	#******************************* 安全类接口 *****************************
	# 注意: 为保护用户数据，仅hosting模式的应用（即将应用部署在腾讯云平台上的应用）才能调用本接口。 
	# 为防止恶意注册/暴力破解/灌水等，保护用户安全和应用信息安全，可以采用要求用户登录/发表留言时输入验证码的方式。
  # 参考: http://wiki.open.qq.com/wiki/v3/csec/captcha_get
  # 返回值 hash:
	# ret 			返回码。详见公共返回码说明#OpenAPI V3.0 返回码。
	# msg 			如果错误，返回错误信息。
	# is_lost 	判断是否有数据丢失。如果应用不使用cache，不需要关心此参数。
	# 					0或者不返回：没有数据丢失，可以缓存。
	# 					1：有部分数据丢失或错误，不要缓存。
	# filename 	验证码jpg图片名称串，在调用“校验图片验证码”接口（v3/csec/captcha_verify）来验证图片合法性和时效性时使用。
	# 					二进制数据流 	验证码jpg图片内容的二进制数据流。 
	# 成功时，返回二进制流图片
	def captcha_get(openid,openkey)
		return api('/v3/csec/captcha_get',
							 "openid" => openid, 
							 "openkey" => openkey)
	end
	#返回二进制流图片用于输入验证码


	# 检查用户的发言、邮件、群组名等信息，对垃圾信息（例如广告、脏话）进行识别。
	# 如果包含有垃圾信息，则给出建议的禁言时长，应用可自行进行相应的处理。 
  # 参考: http://wiki.open.qq.com/wiki/v3/csec/check_spam
  # 返回值 hash:
	# ret 						返回码。详见公共返回码说明#OpenAPI V3.0 返回码。
	# msg 						如果错误，返回错误信息。
	# is_lost 				判断是否有数据丢失。如果应用不使用cache，不需要关心此参数。
	# 								0或者不返回：没有数据丢失，可以缓存。
	# 								1：有部分数据丢失或错误，不要缓存。
  # result 					标识用户输入的信息是否有恶意信息（0：正常； 1：有恶意信息）。
  # forbidden_time 	0：表示用户输入的信息中没有恶意信息，不用进行任何处理；
  # 								大于0：表示用户输入的信息中含有恶意信息，建议对该用户禁言，数值表示建议的禁言时长，以秒为单位
	def check_spam(ctype,content,openid,openkey)
		return api('/v3/csec/check_spam',
						 "openid" => openid, 
						 "openkey" => openkey,
						 "ctype" => ctype,
						 "content" => content,
						 )
	end
	#{"ret"=>0, "is_lost"=>0, "result"=>0, "forbidden_time"=>0}


	#******************************* 好友关系类接口 *****************************
	#注意: 为保护用户数据，仅hosting模式的应用（即将应用部署在腾讯云平台上的应用）才能调用本接口。 
	# 验证是否平台好友，即验证fopenid是否是openid的好友。
	# -腾讯朋友的好友范畴是指在腾讯朋友平台加为好友的人。
	# -QQ空间的好友范畴是指在QQ客户端加为好友的人。
	# -腾讯微博的好友范畴是指在腾讯微博上互相收听的人。
  # 参考: http://wiki.open.qq.com/wiki/v3/user/is_setup
  # 返回值 hash:
	# ret 						返回码。(0:正确返回, [1000,~]错误)
	# msg 						如果错误，返回错误信息。
	# is_lost 				判断是否有数据丢失。如果应用不使用cache，不需要关心此参数。
	# 								0或者不返回：没有数据丢失，可以缓存。
	# 								1：有部分数据丢失或错误，不要缓存。
	# is_friend 			是否为好友（0： 不是好友； >=1： 是好友）当pf=qqgame或pf=3366时，表示是否为QQ好友。
	# is_gamefriend 	是否为QQGame好友（0： 不是QQGame好友； >=1： 是QQGame好友)只有pf=qqgame时，返回此参数） 
	def is_friend?(friend_open_id,openid,openkey)
		return api('/v3/relation/is_friend',
							 "openid" => openid, 
							 "openkey" => openkey,
							 "fopenid" => friend_open_id
							)
	end
	#{"ret"=>0, "is_lost"=>0, "is_friend"=>1}




	# 注意: 为保护用户数据，仅hosting模式的应用（即将应用部署在腾讯云平台上的应用）才能调用本接口。 
	# 本接口是全平台通用的，即发送请求后，可根据请求中传入的“pf”平台参数返回对应平台的信息。
  # 例如：如果传入的pf为qzone，则返回的是在QQ空间安装了应用的好友列表。
  # 参考: http://wiki.open.qq.com/wiki/v3/relation/get_app_friends
  # 返回值 hash:
	# ret 	  	返回码。详见公共返回码说明#OpenAPI V3.0 返回码。
	# msg 	  	如果错误，返回错误信息。
	# is_lost 	判断是否有数据丢失。如果应用不使用cache，不需要关心此参数。
	# 					0或者不返回：没有数据丢失，可以缓存。
	# 					1：有部分数据丢失或错误，不要缓存。
	# openid 		好友QQ号码对应的openid。
	# nickname 	好友昵称（仅当pf=qplus时返回）。 
	def get_app_friends(openid,openkey)
		return api('/v3/relation/get_app_friends',
							 "openid" => openid, 
							 "openkey" => openkey)
	end
	#{"ret"=>0, "is_lost"=>0, "items"=>[{"openid"=>"FEC0BCCE7D4414481D0EF969B516E62D"}, {"openid"=>"DB2673263DF01D1C2BB183269051C8F4"}, {"openid"=>"0A3C349FB613F238992129E8958CF02F"}]}

	# 批量获取多个用户的基本信息，包括昵称、头像等。
	# 参考: http://wiki.open.qq.com/wiki/v3/user/get_multi_info
	# 本接口是全平台通用的，即发送请求后，可根据请求中传入的“pf”平台参数返回对应平台的用户信息。
	# 例如：如果传入的pf为qzone，则返回的是QQ空间的用户信息。
	# 备注：
	# （1）本接口只返回安装了该应用的openid的详细信息。如果传入的fopenids中某个openid并没有安装该应用，则对应的详细信息为空。
	# （2）每次最多可返回100个用户的信息。 
	def get_multi_info(openid,openkey,friend_ids)
		fopenids = friend_ids.join("_")
		# # binding.pry
		return api('/v3/user/get_multi_info',
							 "openid" => openid, 
							 "openkey" => openkey,
							 "fopenids" => fopenids
							)
	end
	
	#******************************* 用户信息类接口 *****************************

  # 返回当前登录用户信息
  # 参考: http://wiki.open.qq.com/wiki/v3/user/get_info
  # return hash
	#		- ret : 返回码 (0:正确返回, [1000,~]错误)
	#		- nickname : 昵称
	#		- gender : 性别
	#		- province : 省
	#		- city : 市
	#		- figureurl : 头像url
	#		- is_vip : 是否黄钻用户 (true|false)
	#		- is_year_vip : 是否年费黄钻(如果is_vip为false, 那is_year_vip一定是false)
  #   - vip_level : 黄钻等级(如果是黄钻用户才返回此字段)      
  def get_user_info(openid,openkey)
    return api('/v3/user/get_info',"openid" => openid, "openkey" => openkey)
  end
  #{"ret"=>0, "is_lost"=>0, "nickname"=>"mile", "gender"=>"女", "country"=>"中国", "province"=>"北京", "city"=>"朝阳", "figureurl"=>"http://thirdapp1.qlogo.cn/qzopenapp/0843a96cac25a31055f3a80984866325ae2b85125dd126e6d802ff383ed6724e/50", "is_yellow_vip"=>0, "is_yellow_year_vip"=>0, "yellow_vip_level"=>0, "is_yellow_high_vip"=>0}

  # 验证登录用户是否安装了应用
  # 参考: http://wiki.open.qq.com/wiki/v3/user/is_setup
  # 返回值 hash:
  #   - ret : 返回码 (0:正确返回, [1000,~]错误)
	#		- setuped : 是否安装(0:没有安装;1:安装)
  def is_setuped?(openid, openkey)
    return api('/v3/user/is_setup',
               "openid" => openid,
               "openkey" => openkey
              )
  end
  #{"ret"=>0, "is_lost"=>0, "setuped"=>1}

  # 判断用户是否为黄钻
  # 参考: http://wiki.open.qq.com/wiki/v3/user/is_vip
  # 返回值 hash:
  #   - ret : 返回码 (0:正确返回, [1000,~]错误)
  #		- is_vip : 是否黄钻 (true:黄钻; false:普通用户)   
  def is_vip?(openid, openkey)
    return api('/v3/user/is_vip',
                "openid" => openid,
                "openkey" => openkey)
  end
  #{"ret"=>0, "is_lost"=>0, "is_yellow_vip"=>0, "is_yellow_year_vip"=>0, "yellow_vip_level"=>0, "is_yellow_high_vip"=>0}


  # 验证用户的登录态，判断openkey是否过期，没有过期则对openkey有效期进行续期（一次调用续期2小时）。
  # 参考: http://wiki.open.qq.com/wiki/v3/user/is_login
  # 返回值 hash:
  #   - ret 	返回码。(0:正确返回, [1000,~]错误)
  #		- msg 	如果错误，返回错误信息。 
  def is_login?(openid, openkey)
    return api('/v3/user/is_login',
                "openid" => openid,
                "openkey" => openkey
              )
  end
  #{"ret"=>0, "msg"=>"user is logged in"}

  # 获取登录用户的所有VIP信息，包括是否为QQ会员，蓝钻，黄钻，红钻，绿钻，粉钻，超级QQ，是否年费（暂不能查询是否年费红钻和绿钻），以及VIP等级。 
 	# 注意：
	# （1）本接口返回的各种VIP信息是实时的，适用于需要VIP信息特别准确的场景（例如领取礼包场景中，非VIP用户开通VIP后，返回应用应该立即可领取礼包）。
	# （2）v3/user/get_info接口中也返回了用户的部分VIP信息，但是该接口返回的VIP信息是经过缓存的，有一定的延时。
	# （3）v3/user/is_vip接口中也返回了黄钻相关信息，与本接口返回的信息是一致的，即如果想获得实时黄钻信息，用2个接口都可以。 
  # 参考: http://wiki.open.qq.com/wiki/v3/user/total_vip_info
  # return hash:
	# ret 						返回码。详见公共返回码说明#OpenAPI V3.0 返回码。
	# msg 						如果错误，返回错误信息。
	# is_lost 				判断是否有数据丢失。如果应用不使用cache，不需要关心此参数。
	# 								0或者不返回：没有数据丢失，可以缓存。
	# 								1：有部分数据丢失或错误，不要缓存。
	# is_vip 					是否为QQ会员（0：不是； 1：是）
	# is_year_vip 		是否是年费QQ会员（0：不是； 1：是）
	# vip_level 			QQ会员等级
	# is_blue 				是否为蓝钻用户（0：不是； 1：是）
	# is_year_blue 	  是否是年费蓝钻用户（0：不是； 1：是）
	# blue_level 			蓝钻等级
	# is_yellow 			是否为黄钻用户（0：不是； 1：是）
	# is_year_yellow 	是否是年费黄钻用户（0：不是； 1：是）
	# yellow_level 		黄钻等级
	# is_red 					是否为红钻用户（0：不是； 1：是）
	# red_level 			红钻等级
	# is_green 				是否为绿钻用户（0：不是； 1：是）
	# green_level 		绿钻等级
	# is_pink 				是否为粉钻用户（0：不是； 1：是）
	# is_year_pink 		是否是年费粉钻用户（0：不是； 1：是）
	# pink_level 			粉钻等级
	# is_superqq 			是否为超级QQ用户（0：不是； 1：是）
	# superqq_level 	超级QQ等级 
  def total_vip_info(openid,openkey, member_vip, blue_vip, yellow_vip, red_vip, green_vip, pink_vip, superqq)
    return api('/v3/user/total_vip_info',
             "openid" => openid,
             "openkey" => openkey,
             "member_vip" => member_vip, 
             "blue_vip" => blue_vip, 
             "yellow_vip" => yellow_vip, 
             "red_vip" => red_vip, 
             "green_vip" => green_vip, 
             "pink_vip" => pink_vip, 
             "superqq" => superqq
           )
  end


end