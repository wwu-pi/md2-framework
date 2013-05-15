package de.wwu.md2.framework.ui.autoedit;

import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.DefaultIndentLineAutoEditStrategy;
import org.eclipse.jface.text.DocumentCommand;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IRegion;

/**
 * This class provides a auto edit strategy for the indentation of the steps within a wokflow in the MD2 language
 * definition.
 * 
 * It works as follows: If we are currently in a line '{@code step anyIdentifier:}'
 * and press enter, the next line will get indented. Furthermore, it is checked whether the current
 * step was the first step definition within the workflow block. If that is not the case the line with
 * the current step declaration will be outdented (to compensate the indentation of the previous step block).
 * We will get a well formatted code block of the form:
 * 
 * <pre>
 * workflow anyWorkflow {
 *     step anyFirstStep:
 *         // further code
 *     
 *     step anySecondStep:
 *         // further code
 *     
 *     ...
 * }
 * </pre>
 */
public class WorkflowStepsAutoIndentStrategy extends DefaultIndentLineAutoEditStrategy {
	
	/**
	 * Starting point. Checks whether a new line command has been entered. If that is the case
	 * it is checked whether the current line was a 'step' definition of a workflow and the indentation
	 * is handled neatly.
	 */
	@Override
	public void customizeDocumentCommand(IDocument d, DocumentCommand c) {
		if (this.isInsertNewLineCommand(d, c)) {
			this.autoIndentAfterNewLine(d, c);
		}
	}
	
	/**
	 * Check whether the given string {@code newLineCandidate} equals any end of line identifier.
	 * 
	 * @param document The document we are currently operating on.
	 * @param newLineCandidate The string that should be checked for equality with any end of line identifier.
	 * @return True if the newLineCandidate is an end of line identifier.
	 */
	protected boolean isNewLine(IDocument document, String newLineCandidate) {
		String[] lineDelimiters = document.getLegalLineDelimiters();
		for (int i = 0; i < lineDelimiters.length; i++)
			if (newLineCandidate.equals(lineDelimiters[i]))
				return true;
		return false;
	}
	
	/**
	 * Check if any command has been entered. If so, check whether it was a new line command.
	 * 
	 * @param document
	 * @param command
	 * @return
	 */
	protected boolean isInsertNewLineCommand(IDocument document, DocumentCommand command) {
		return command.length == 0 && this.isNewLine(document, command.text);
	}
	
	/**
	 * Get a block indentation char (tabulator)
	 * @return Tabulator.
	 */
	protected String blockIndentation() {
		return "\t";
	}
	
	/**
	 * Checks whether a new step block has been declared.
	 * 
	 * @param document
	 * @param lineStart
	 * @param offset
	 * @return
	 * @throws BadLocationException
	 */
	protected boolean isBeginOfNewBlock(IDocument document, int lineStart, int offset) throws BadLocationException {
		String line = document.get(lineStart, offset - lineStart);
		String trimmedLine = line.trim();
		return trimmedLine.matches("step.+:");
	}
	
	/**
	 * Iterate the current document line by line upwards, starting at the line represented by the
	 * current position. If the keyword 'workflow' is found without finding a 'step' keyword before,
	 * this is the first occurrence of step in the current workflow block (return true). In case that
	 * a step keyword is found return false.
	 * 
	 * @param document The actual document.
	 * @param previousLineStart First position of the line from which the search should be started.
	 * @return true if this is the first occurrence of step in the current workflow block, otherwise false.
	 */
	protected boolean isFirstOccurrenceOfStepInWorkflow(IDocument document, int previousLineStart) {
		
		IRegion lineRegion;
		String line;
		
		try {
			// iterate through the lines
			while(previousLineStart - 1 > 0) {
				lineRegion = document.getLineInformationOfOffset(previousLineStart - 1);
				line = document.get(lineRegion.getOffset(), lineRegion.getLength());
				
				if(line.matches(".*step.+:.*")) {
					return false;
				} else if(line.matches(".*workflow.+\\{.*")) {
					return true;
				}
				
				previousLineStart = lineRegion.getOffset();
			}
			
		} catch(BadLocationException e) {
			 // just handle this problem gracefully and return true (a bad indentation won't hurt)
		}
		
		return true;
	}
	
	/**
	 * In this method the actual magic happens. If we are currently in a line '{@code step anyIdentifier:}'
	 * and press enter, the next line will get indented. Furthermore, it is checked whether the current
	 * step was the first step definition within the workflow block. If that is not the case the line with
	 * the current step declaration will be outdented (to compensate the indentation of the previous step block).
	 * We will get a well formatted code block of the form:
	 * 
	 * <pre>
	 * workflow anyWorkflow {
	 *     step anyFirstStep:
	 *         // further code
	 *     
	 *     step anySecondStep:
	 *         // further code
	 *     
	 *     ...
	 * }
	 * </pre>
	 * 
	 * @param document
	 * @param command
	 */
	protected void autoIndentAfterNewLine(IDocument document, DocumentCommand command) {
		if (command.offset == -1 || document.getLength() == 0) {
			return;
		}
		
		try {
			int p = (command.offset == document.getLength() ? command.offset - 1 : command.offset);
			IRegion info = document.getLineInformationOfOffset(p);
			int lineStart = info.getOffset();
			int endOfWhiteSpace = this.findEndOfWhiteSpace(document, lineStart, command.offset);
			StringBuffer buffer = new StringBuffer();
			
			if (this.isBeginOfNewBlock(document, lineStart, command.offset)) {
				// first outdent the current line (if it is not the first occurrence of 'step'
				// in the workflow block)
				if (!isFirstOccurrenceOfStepInWorkflow(document, lineStart) && endOfWhiteSpace > lineStart) {
					document.replace(lineStart, 1, ""); // remove one indentation from the beginning of the line
					endOfWhiteSpace--;
					command.offset--;
				}
				
				// then:
				// 1. go to new line,
				// 2. append the current indentation in the new line
				// 3. append one more indentation in new line
				buffer.append(command.text);
				buffer.append(document.get(lineStart, endOfWhiteSpace - lineStart));
				buffer.append(this.blockIndentation());
			}
			else {
				// just step into new line, the standard new line indentation handler will do the rest
				buffer.append(command.text);
			}
			
			command.text = buffer.toString();
		
		} catch (BadLocationException e) {
			e.getStackTrace();
		}
	}

}
