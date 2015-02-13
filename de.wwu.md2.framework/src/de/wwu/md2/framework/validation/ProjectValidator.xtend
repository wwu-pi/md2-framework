package de.wwu.md2.framework.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.util.MD2Util

/**
 * Validators for all high-level elements (model, view, workflow and controller).
 */
class ProjectValidator extends AbstractMD2JavaValidator {
    
    @Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    @Inject
    private MD2Util util;
    
    /**
     * Enforce that the declared package name complies with the actual package location
     * 
     * @param model
     */
    @Check
    def checkPackageNameCompliesWithLocation(MD2Model model) {
        val pkgName = util.getPackageNameFromPath(model.eResource().getURI());
        if(!model.getPackage().getPkgName().equals(pkgName)) {
            warning("The specified package does not match the actual location of the file", MD2Package.eINSTANCE.getMD2Model_Package());
        }
    }
    
    
    public static final String MODELELEMENT_PACKAGE = "modelelement_package";
    /**
     * Ensure that all elements belonging to a certain layer are stored in the appropriate
     * package. E.g., throw an error if a view is stored in the package models.
     * 
     * @param model
     */
    @Check
    def checkModelElementCompliesWithPackage(MD2Model model) {
        
        // split package name
        var lst = model.getPackage().getPkgName().split("\\.")

        val modelLayer = model.getModelLayer()
        
        if (modelLayer instanceof Model && !lst.contains("models")) {
            error("You tried to put a model element in a non-model package", MD2Package.eINSTANCE.getMD2Model_ModelLayer(), -1, MODELELEMENT_PACKAGE);
        } else if (modelLayer instanceof View && !lst.contains("views")) {
            error("You tried to put a view element in a non-view package", MD2Package.eINSTANCE.getMD2Model_ModelLayer(), -1, MODELELEMENT_PACKAGE);
        } else if (modelLayer instanceof Controller && !lst.contains("controllers")) {
            error("You tried to put a controller element in a non-controller package", MD2Package.eINSTANCE.getMD2Model_ModelLayer(), -1, MODELELEMENT_PACKAGE);
        } else if (modelLayer instanceof Workflow && !lst.contains("workflows")) {
            error("You tried to put a workflow element in a non-workflow package", MD2Package.eINSTANCE.getMD2Model_ModelLayer(), -1, MODELELEMENT_PACKAGE);
        }
    }
    
}