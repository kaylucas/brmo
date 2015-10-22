/*
 * Copyright (C) 2015 B3Partners B.V.
 */
package nl.b3p.brmo.loader.xml;

import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.Date;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stax.StAXResult;
import javax.xml.transform.stax.StAXSource;
import nl.b3p.brmo.loader.entity.BagBericht;
import nl.b3p.brmo.loader.entity.Bericht;
import nl.b3p.brmo.loader.entity.NhrBericht;
import static nl.b3p.brmo.loader.xml.BagXMLReader.LVC_PRODUCT;
import static nl.b3p.brmo.loader.xml.BagXMLReader.MUTATIE_PRODUCT;
import static nl.b3p.brmo.loader.xml.BagXMLReader.lvcProductToObjectType;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 * Reader voor NHR xml berichten.
 *
 * @author Mark Prins <mark@b3partners.nl>
 */
public class NhrXMLReader extends BrmoXMLReader {

    private static final Log log = LogFactory.getLog(NhrXMLReader.class);

    private static final String LV_DATUM_TIJD = "datumtijdstempelLV";
    private static final String LV_KENMERK = "kenmerkLV";
    private static final String KVK_REGISTRATIE_TIJDSTIP = "registratieTijdstip";
    private static final String KVK_NUMMER = "kvkNummer";
    private static final String MAATSCHAPPELIJKE_ACTIVITEIT = "maatschappelijkeActiviteit";

    private final XMLInputFactory factory = XMLInputFactory.newInstance();
    private final XMLStreamReader streamReader;
    private final Transformer transformer;
    private final DocumentBuilder builder;
    private final XMLOutputFactory xmlof;

    public NhrXMLReader(InputStream in) throws XMLStreamException,
            TransformerConfigurationException,
            ParserConfigurationException {

        streamReader = factory.createXMLStreamReader(in);

        TransformerFactory tf = TransformerFactory.newInstance();
        transformer = tf.newTransformer();

        xmlof = XMLOutputFactory.newInstance();
        xmlof.setProperty(XMLOutputFactory.IS_REPAIRING_NAMESPACES, Boolean.TRUE);

        DocumentBuilderFactory dbfactory = DocumentBuilderFactory.newInstance();
        dbfactory.setNamespaceAware(true);

        builder = dbfactory.newDocumentBuilder();

        init();
    }

    @Override
    public void init() throws XMLStreamException {
        positionToNext();
    }

    private void positionToNext() throws XMLStreamException {
        try {
            while (streamReader.hasNext()) {
                if (streamReader.isStartElement()) {
                    String localName = streamReader.getLocalName();
                    log.debug("begin node:" + localName);

                    if (localName.equals(MAATSCHAPPELIJKE_ACTIVITEIT)) {
                        // zet stream aan begin van VerstrekkingDoorLV/gebeurtenisinhoud/maatschappelijkeActiviteit
                        // voor next()
                        break;
                    }
                    if (localName.equals(LV_DATUM_TIJD)) {
                        // 2013-02-26T16:40:05+01:00
                        setDatumAsString(streamReader.getElementText());
                    }
                    if (localName.equals(LV_KENMERK)) {
                        setBestandsNaam(localName);
                    }
                }
                streamReader.next();
            }
        } catch (XMLStreamException ex) {
            log.error("Error while streaming XML", ex);
        }
    }

    @Override
    public boolean hasNext() throws Exception {
        try {
            return streamReader.hasNext();
        } catch (XMLStreamException ex) {
            log.error("Error while streaming XML", ex);
        }
        return false;
    }

    @Override
    public NhrBericht next() throws Exception {
        NhrBericht b = null;
        try {
            if (streamReader.isStartElement()) {
                log.debug("next node:" + streamReader.getLocalName());
                StringWriter sw = new StringWriter();

                transformer.transform(new StAXSource(streamReader), new StAXResult(xmlof.createXMLStreamWriter(sw)));
                Document d = builder.parse(new InputSource(new StringReader(sw.toString())));

                b = new NhrBericht(sw.toString());

            }
        } catch (XMLStreamException ex) {
            log.error("Error while streaming XML", ex);
        }
        positionToNext();
        return b;
    }

}
