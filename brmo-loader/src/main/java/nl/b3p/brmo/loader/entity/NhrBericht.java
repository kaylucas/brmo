/*
 * Copyright (C) 2015 B3Partners B.V.
 */
package nl.b3p.brmo.loader.entity;

import java.io.StringReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import static nl.b3p.brmo.loader.BrmoFramework.BR_NHR;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

/**
 * Handelsregister bericht.
 *
 * @author Mark Prins <mark@b3partners.nl>
 */
public class NhrBericht extends Bericht {

    private static final Log log = LogFactory.getLog(NhrBericht.class);

    static {
        XPathFactory xPathfactory = XPathFactory.newInstance();
        XPath xpath = xPathfactory.newXPath();

        try {
            // todo
            xpath.compile("");
        } catch (XPathExpressionException ex) {
            log.fatal("Fout bij initialiseren XPath expressies", ex);
        }
    }
    private boolean xpathEvaluated = false;

    public NhrBericht(String brXml) {
        super(brXml);
        setSoort(BR_NHR);
    }

    public void setDatumAsString(String d) {
        if (d == null || d.isEmpty()) {
            return;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        try {
            setDatum(sdf.parse(d));
        } catch (ParseException pe) {
            log.error("Error while parsing date: " + d, pe);
        }
    }

    private void evaluateXPath() {
        if (xpathEvaluated) {
            return;
        }

        xpathEvaluated = true;
        try {

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(getBrXml())));

            XPathFactory xPathfactory = XPathFactory.newInstance();
            XPath xpath = xPathfactory.newXPath();

            // TODO
        } catch (Exception e) {
            log.error("Error while getting brk referentie", e);
        }
    }
}
