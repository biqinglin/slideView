# slideView
三张卡片无限复用，最大程度节省对象开销<br>
![image](http://occmuwiio.bkt.clouddn.com/show.gif)
<br>
原理：修改卡片frame
<br>
这里有个bug：快速滑动产生空白。
<br>
解决：删除scrollView的手势，手动添加左滑右滑手势，一次滑动一个卡片。
<br>
如果需要快速滑动，在这个例子中需要增加卡片数量至：5张或者6张进行复用

