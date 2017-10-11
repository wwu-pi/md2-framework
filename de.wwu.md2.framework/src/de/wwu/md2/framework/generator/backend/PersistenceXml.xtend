package de.wwu.md2.framework.generator.backend

class PersistenceXml {
	
	def static createPersistenceXml(String basePackageName) '''		
	<?xml version="1.0" encoding="UTF-8" ?>
	<persistence xmlns="http://java.sun.com/xml/ns/persistence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0" xsi:schemaLocation="http://java.sun.com/xml/ns/persistence http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd">
	  <persistence-unit name="«basePackageName»"	transaction-type="JTA">
	   <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
	      
	        <properties>
	            <property name="hibernate.dialect" value="org.hibernate.dialect.H2Dialect"/>
	            <!-- value="create" to build a new database on each run; value="update" to modify an existing database; value="create-drop" means the same as "create" but also drops tables when Hibernate closes; value="validate" makes no changes to the database -->
	            <property name="hibernate.hbm2ddl.auto" value="create"/>
	            <property name="hibernate.ejb.naming_strategy" value="org.hibernate.cfg.ImprovedNamingStrategy"/>
	            <property name="hibernate.connection.charSet" value="UTF-8"/>
				  <property name="hibernate.show_sql" value="true"/>
	            <property name="hibernate.format_sql" value="true"/>
	            <!-- Uncomment the following two properties for JBoss only -->
	            <!-- property name="hibernate.validator.apply_to_ddl" value="false" /-->
	            <!-- property name="hibernate.validator.autoregister_listeners" value="false" /-->
	        </properties>
	   </persistence-unit>
	</persistence>    
	
	'''


def static createPom(String basePackageName){ '''
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>«basePackageName»</groupId>
  <artifactId>«basePackageName»</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>war</packaging>
  <build>
        <finalName>«basePackageName»</finalName>
    <sourceDirectory>src</sourceDirectory>
    <resources>
      <resource>
        <directory>src</directory>
        <excludes>
          <exclude>**/*.java</exclude>
        </excludes>
      </resource>
    </resources>
    <plugins>
      <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.5.1</version>
        <configuration>
               <failOnMissingWebXml>false</failOnMissingWebXml> 
          <source>1.6</source>
          <target>1.6</target>
        </configuration>
      </plugin>
      <plugin>
        <artifactId>maven-war-plugin</artifactId>
        <version>3.0.0</version>
        <configuration>
               <failOnMissingWebXml>false</failOnMissingWebXml> 
          <warSourceDirectory>WebContent</warSourceDirectory>
        </configuration>
      </plugin>
    </plugins>
  </build>
  <dependencies>
<dependency>
    <groupId>javax</groupId>
    <artifactId>javaee-api</artifactId>
    <version>7.0</version>
    <scope>provided</scope>
</dependency>
<!-- https://mvnrepository.com/artifact/com.google.guava/guava -->
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>13.0.1</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.codehaus.jackson/jackson-xc -->
<dependency>
    <groupId>org.codehaus.jackson</groupId>
    <artifactId>jackson-xc</artifactId>
    <version>1.9.13</version>
</dependency>
<!-- https://mvnrepository.com/artifact/com.googlecode.json-simple/json-simple -->
<dependency>
    <groupId>com.googlecode.json-simple</groupId>
    <artifactId>json-simple</artifactId>
    <version>1.1.1</version>
    <!-- https://mvnrepository.com/artifact/org.codehaus.jackson/jackson-mapper-asl -->
</dependency>

<dependency>
    <groupId>org.codehaus.jackson</groupId>
    <artifactId>jackson-mapper-asl</artifactId>
    <version>1.9.13</version>
</dependency>
<!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.jaxrs/jackson-jaxrs-json-provider -->
<dependency>
    <groupId>com.fasterxml.jackson.jaxrs</groupId>
    <artifactId>jackson-jaxrs-json-provider</artifactId>
    <version>2.8.8</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.codehaus.jackson/jackson-core-asl -->
<dependency>
    <groupId>org.codehaus.jackson</groupId>
    <artifactId>jackson-core-asl</artifactId>
    <version>1.9.13</version>
</dependency>


  </dependencies>
</project>	
	'''}
}
