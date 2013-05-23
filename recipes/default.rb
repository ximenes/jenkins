#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "download_java" do 
  command "wget --no-check-certificate --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com"  "http://download.oracle.com/otn-pub/java/jdk/7u21-b11/jdk-7u21-linux-i586.tar.gz" -P /home/"
  action :run
end


execute "descompact_java" do
  command "tar -zxvf /home/jdk-7u21-linux-i586.tar.gz -C /opt/"
  action :run
end


execute "download_jboss" do 
  command "wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz -P /home/"
  action :run
end

execute "configure_jboss" do 
  command "tar -zxvf /home/jboss-as-7.1.1.Final.tar.gz -C /opt/"
  action :run
end

cookbook_file "/opt/jboss-as-7.1.1.Final/bin/standalone.sh" do 
  source "standalone.sh"
  mode 0755
  owner "root"
  group "root"
end  

cookbook_file "/opt/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml" do 
  source "standalone.xml"
  mode 0755
  owner "root"
  group "root"
end  

execute "jenkins_download" do
  command "wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war -P /opt/jboss-as-7.1.1.Final/standalone/deployments/"
  action :run
end


package "monit" do
  action :install
end

cookbook_file "/etc/monit/conf.d/jboss" do
  source "monit_jboss"
  mode 0644
  owner "root"
  group "root"
end

service "monit" do
  action :restart
end

