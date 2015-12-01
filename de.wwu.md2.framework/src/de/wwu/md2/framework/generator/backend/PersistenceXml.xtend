package de.wwu.md2.framework.generator.backend

class PersistenceXml {
	
	def static createPersistenceXml(String basePackageName) '''
		<?xml version="1.0" encoding="UTF-8"?>
		<persistence version="2.0" xmlns="http://java.sun.com/xml/ns/persistence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		             xsi:schemaLocation="http://java.sun.com/xml/ns/persistence http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd">
			<persistence-unit name="«basePackageName»">
			    <provider>org.eclipse.persistence.jpa.PersistenceProvider</provider>
		        <jta-data-source>java:app/env/«basePackageName»</jta-data-source>
		        <properties>
		            <property name="eclipselink.ddl-generation" value="create-tables" />
		            <!-- property name="eclipselink.ddl-generation" value="drop-and-create-tables" / -->
		            <property name="eclipselink.ddl-generation.output-mode" value="database" />
		        </properties>
			</persistence-unit>
		</persistence>
	'''
}
