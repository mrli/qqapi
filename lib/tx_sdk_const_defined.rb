#encoding: utf-8

#***********************涉及到的第三方库***************************
require 'json'
require 'net/http'
require 'uri'
require "pry"
require "uri-handler"
require 'digest/sha1'
require 'base64'

#***********************错误代码定义***************************
# 参数为空
PYO_ERROR_REQUIRED_PARAMETER_EMPTY = 2001
# 参数格式果物
PYO_ERROR_REQUIRED_PARAMETER_INVALID = 2002
# 返回包格式错误
PYO_ERROR_RESPONSE_DATA_INVALID = 2003
# 网络错误, 偏移量3000, 详见 http://curl.haxx.se/libcurl/c/libcurl-errors.html
PYO_ERROR_CURL = 3000
