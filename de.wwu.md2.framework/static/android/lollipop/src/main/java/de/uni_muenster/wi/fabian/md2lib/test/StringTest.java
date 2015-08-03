package de.uni_muenster.wi.fabian.md2lib.test;

import org.junit.Test;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;

/**
 * Created by Fabian on 12.07.2015.
 */
public class StringTest {

    @org.junit.Test
    public void createInstance(){

        String str = new String("test");
        org.junit.Assert.assertNotNull(str);
        org.junit.Assert.assertEquals("Should be the same string", "test", str.getPlatformValue());
    }

    @org.junit.Test
    public void equal(){

        org.junit.Assert.assertEquals("Should be the same string", "test", "test");
    }
}
