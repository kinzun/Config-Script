#!/bin/bash
#description: Fast deployment speed 
#
#set PATH 
#
javahome=/usr
tomcathome=/usr/local/tomcat
#__________

case "$1" in
java)
#install set java
#
itjava(){
rpm -qa |grep java > /dev/null 2>&1 
if [ "$?" -ne 0 ] ;then
	yum install java -y  > /dev/null 2>&1

	echo "install java successfully"
fi
}

itjava
#set path
javapathset(){
cat > /etc/profile.d/java.sh <<EOF
export JAVA_HOME=$javahome
export PATH=$JAVA_HOME/bin:$PATH
EOF
}
javapathset
chmod +x /etc/profile.d/java.sh
echo "JAVA_PATH complection"
echo "PRESS ANY KEY TO EXIT"
;;

tomcat)
# install set tomcat
#
ittomcat(){
rpm -qa |grep tomcat > /dev/null 2>&1
if [ "$?" -ne 0 ] ;then
	yum install tomcat -y > /dev/null 2>&1
echo "install tomcat successfully"
fi
echo "PRESS ANY KEY TO EXIT"
}

ittomcat
# set path
tomcatpathset(){
cat > /etc/profile.d/tomcat.sh <<EOF
export CATALINA_BASE=$tomcathome 
export PATH=$CATALINA_BASE/bin:$PATH
EOF
}
#tomcatpathset
#chmod +x /etc/profile.d/tomcat.sh
echo "tomcat complection"
;;
# session test page
mktest)

testpage(){
testpagepath=/usr/share/tomcat/webapps

mkdir $testpagepath/{lib,class,WEB-INF,META-INF} -pv
cat > $testpagepath/index.jsp <<EOF
<%@ page language="java" %>
<html>
  <head><title>TomcatA</title></head>
  <body>
    <h1><font color="red">TomcatA.magedu.com</font></h1>
    <table align="centre" border="1">
      <tr>
        <td>Session ID</td>
    <% session.setAttribute("magedu.com","magedu.com"); %>
        <td><%= session.getId() %></td>
      </tr>
      <tr>
        <td>Created on</td>
        <td><%= session.getCreationTime() %></td>
     </tr>
    </table>
  </body>
</html>
EOF
}

testpage
;;
*)
    echo "Usage: $0 {java|tomcat|mktest}"
    echo "PRESS ANY KEY TO EXIT"
    exit 1
esac

exit 0
