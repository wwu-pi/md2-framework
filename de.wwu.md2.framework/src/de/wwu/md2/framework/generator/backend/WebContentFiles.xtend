package de.wwu.md2.framework.generator.backend

class WebContentFiles {
	
	def static manifest() '''
		Manifest-Version: 1.0
		Class-Path: 
		
	'''
	
	def static sunWebXml(String basePackageName) '''
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE sun-web-app PUBLIC "-//Sun Microsystems, Inc.//DTD Application Server 9.0 Servlet 2.5//EN" "http://www.sun.com/software/appserver/dtds/sun-web-app_2_5-0.dtd">
		<sun-web-app error-url="">
		  <context-root>/«basePackageName»</context-root>
		  <class-loader delegate="true"/>
		  <jsp-config>
		    <property name="keepgenerated" value="true">
		      <description>Keep a copy of the generated servlet class java code.</description>
		    </property>
		  </jsp-config>
		</sun-web-app>
	'''
	
	def static webXml(String basePackageName) '''
		<?xml version="1.0" encoding="UTF-8"?>
		<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://java.sun.com/xml/ns/javaee" xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd" xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd" id="WebApp_ID" version="3.0">
		  <display-name>«basePackageName»</display-name>
		  <servlet>
		    <servlet-name>Jersey REST Service</servlet-name>
		    <servlet-class>com.sun.jersey.spi.container.servlet.ServletContainer</servlet-class>
		    <init-param>
		      <param-name>com.sun.jersey.config.property.packages</param-name>
		      <param-value>«basePackageName».ws;org.codehaus.jackson.jaxrs</param-value>
		    </init-param>
		    <load-on-startup>1</load-on-startup>
		  </servlet>
		  <servlet-mapping>
		    <servlet-name>Jersey REST Service</servlet-name>
		    <url-pattern>/service/*</url-pattern>
		  </servlet-mapping>
			<data-source>
				<name>java:app/env/«basePackageName»</name>
				<class-name>org.apache.derby.jdbc.ClientXADataSource</class-name>
				<server-name>localhost</server-name>
				<port-number>1527</port-number>
				<database-name>«basePackageName»</database-name>
				<user>APP</user>
				<password>APP</password>
				<property>
					<name>connectionAttributes</name>
					<value>;create=true</value>
				</property>
			</data-source>
		</web-app>
	'''
	
	def static indexJsp() '''
		<%@page contentType="text/html" pageEncoding="UTF-8"%>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
				<title>MD2 Web Services</title>
			</head>
			<body>
				<p>The MD<sup>2</sup> backend server is up and running!</p>
			</body>
		</html>
	'''
	
}