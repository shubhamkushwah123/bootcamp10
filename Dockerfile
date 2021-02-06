FROM library/tomcat
ADD target/addressbook.war /usr/local/tomcat/webapps
EXPOSE 8081
CMD "catalina.sh" "run"

