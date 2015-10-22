package nl.b3p.brmo.loader.xml;

import nl.b3p.brmo.loader.entity.NhrBericht;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Testcases voor {@link nl.b3p.brmo.loader.xml.NhrBericht}.
 *
 * @author Mark Prins <mark@b3partners.nl>
 */
public class NhrXMLReaderTest {
    
    private static final String gebeurtenis17 = "17GebeurtenisWijzigenHandelsnaamProduct.StUF.xml";
    private static final String gebeurtenis18 = "18GebeurtenisWijzigenNatuurlijkPersoonProduct.StUF.xml";
    private static final String gebeurtenis19 = "19GebeurtenisZetelverplaatsingNaarBuitenlandProduct.StUF.xml";

    /**
     * Test bericht 17.
     *
     * @throws Exception if any
     */
    @Test
    public void test17() throws Exception {
        NhrXMLReader nReader;
        NhrBericht nhr = null;
        nReader = new NhrXMLReader(NhrXMLReaderTest.class.getResourceAsStream(gebeurtenis17));
        assertTrue(nReader.hasNext());
        nhr = nReader.next();
        assertNotNull(nhr);
        System.out.println(nhr);
    }

    /**
     * Test bericht 18.
     *
     * @throws Exception if any
     */
    @Test
    public void test18() throws Exception {
        NhrXMLReader nReader;
        NhrBericht nhr = null;
        nReader = new NhrXMLReader(NhrXMLReaderTest.class.getResourceAsStream(gebeurtenis18));
        assertTrue(nReader.hasNext());
        nhr = nReader.next();
        assertNotNull(nhr);
        System.out.println(nhr);
    }

    /**
     * Test bericht 19.
     *
     * @throws Exception if any
     */
    @Test
    public void test19() throws Exception {
        NhrXMLReader nReader;
        NhrBericht nhr = null;
        nReader = new NhrXMLReader(NhrXMLReaderTest.class.getResourceAsStream(gebeurtenis19));
        assertTrue(nReader.hasNext());
        nhr = nReader.next();
        assertNotNull(nhr);
        System.out.println(nhr);
    }
}
