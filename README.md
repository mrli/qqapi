qqapai 用rails封装腾讯开放平台的api
=====



使用的时候请把lib中的文件copy到自己的项目lib文件中

cd /tmp/ && git clone https://github.com/mrli/qqapi.git \
cd qqapi && cp lib/*.rb you_project/lib/

测试
=====
请先执行 bundle install # cd qqapi && bundle install
其实也没有什么依赖的gem包,主要是用一个"pry"用于调试

注意: 现在我只是封装了部分的接口,还有些没有做,希望你在学习和使用时贡献力量 :)
	    在提交时写清楚加了哪些接口和功能等
