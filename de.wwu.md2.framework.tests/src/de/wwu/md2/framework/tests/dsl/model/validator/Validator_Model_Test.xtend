package de.wwu.md2.framework.tests.dsl.model.validator

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import de.wwu.md2.framework.mD2.MD2Model
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*
import static extension org.junit.Assert.*
import org.junit.Before
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.EList
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import java.util.List
import de.wwu.md2.framework.mD2.AttrEnumDefault

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class Validator_Model_Test {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model model_Testmodel;
	
	ResourceSet rs;
	private EList<ModelElement> elements;
	private List<Entity> entities;
	private List<Enum> enums;
	private AttrEnumDefault enumDefault;
	
		//Loads the different Elements of the Model into the corresponding variables
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		model_Testmodel = COMPLETE_MODEL_M.load.parse(rs);
		elements = (model_Testmodel.modelLayer as Model).modelElements;
		entities = elements.filter(typeof(Entity)).toList;
		enums = elements.filter(typeof(Enum)).toList;
//		book = entities.get(0);
//		copy = entities.get(1);	
//		person = entities.get(2);
	}
	
	@Test
	def testDefaultValueForReference() {
//		model_Testmodel.assertError(AttrEnumDefault, DEFAULTREFERENCEVALUE);
	}
	
}