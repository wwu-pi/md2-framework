package de.wwu.md2.framework.generator.backend

class ValidationResult {
	
	def static createValidationResult(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import java.util.List;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		/**
		 * Object that contains the validation result of a remote validator.
		 */
		@XmlRootElement
		public class ValidationResult {
			
			@XmlElement
			protected boolean ok;
			
			@XmlElement
			protected List<ValidationError> errors;
			
			protected ValidationResult() {
				// no-arg default constructor necessary
			}
			
			public ValidationResult(boolean ok) {
				this.ok = ok;
			}
			
			public ValidationResult appendError(ValidationError error) {
				
				if(this.ok) {
					throw new UnsupportedOperationException("Tried to add a ValidationError to a result object with validation result 'ok'.");
				}
				
				this.errors.add(error);
				return this;
			}
		}
	'''
	
	def static createValidationError(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import java.util.List;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class ValidationError {
			
			@XmlElement
			protected String message;
			
			@XmlElement
			protected List<String> attributes;
			
			protected ValidationError() {
				// no-arg default constructor necessary
			}
			
			public ValidationError(String message) {
				this.message = message;
			}
			
			public ValidationError appendAttribute(String attributeName) {
				this.attributes.add(attributeName);
				return this;
			}
		}
	'''
	
}