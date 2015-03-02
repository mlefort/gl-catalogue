package org.fao.geonet.kernel;

import jeeves.server.UserSession;
import jeeves.server.context.ServiceContext;
import org.fao.geonet.AbstractCoreIntegrationTest;
import org.fao.geonet.domain.ISODate;
import org.fao.geonet.domain.Metadata;
import org.fao.geonet.domain.MetadataType;
import org.fao.geonet.repository.MetadataRepository;
import org.jdom.Element;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;

import static org.fao.geonet.constants.Geonet.Namespaces.GCO;
import static org.fao.geonet.constants.Geonet.Namespaces.GMD;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

/**
 * Test that the aspect defined work correctly.
 * <p/>
 * Created by Jesse on 3/10/14.
 */
public class DataManagerWorksWithoutTransactionIntegrationTest extends AbstractCoreIntegrationTest {
    @Autowired
    DataManager _dataManager;
    @Autowired
    MetadataRepository _metadataRepository;

    @Autowired
    PlatformTransactionManager _tm;

    @Test
    public void testDataManagerCutpoints() throws Exception {
        TransactionlessTesting.get().run
                (new TestTask() {
                    @Override
                    public void run() throws Exception {
                        final ServiceContext serviceContext = createServiceContext();
                        loginAsAdmin(serviceContext);

                        final Element sampleMetadataXml = getSampleMetadataXml();
                        final UserSession userSession = serviceContext.getUserSession();
                        final int userIdAsInt = userSession.getUserIdAsInt();
                        final String mdId = _dataManager.insertMetadata(serviceContext, "iso19139", sampleMetadataXml,
                                "uuid" + _inc.incrementAndGet(), userIdAsInt, "2", "source",
                                MetadataType.METADATA.codeString, null, "maps", new ISODate().getDateAndTime(),
                                new ISODate().getDateAndTime(), false, false);
                        Element newMd = new Element("MD_Metadata", GMD).addContent(new Element("fileIdentifier",
                                GMD).addContent(new Element("CharacterString", GCO)));
                        _dataManager.indexMetadata(mdId, true);

                        Metadata updateMd = _dataManager.updateMetadata(serviceContext, mdId, newMd, false, false, false, "eng",
                                new ISODate().getDateAndTime(), false);
                        assertNotNull(updateMd);
                        final boolean hasNext = updateMd.getCategories().iterator().hasNext();
                        assertTrue(hasNext);
                    }
                });

    }

    @Test
    public void testSetHarvesterData() throws Exception {
        TransactionlessTesting.get().run
                (new TestTask() {
                    @Override
                    public void run() throws Exception {
                        final ServiceContext serviceContext = createServiceContext();
                        loginAsAdmin(serviceContext);

                        final DataManagerWorksWithoutTransactionIntegrationTest test =
                                DataManagerWorksWithoutTransactionIntegrationTest.this;
                        final int metadataId =  DataManagerIntegrationTest.importMetadata(test, serviceContext);

                        DataManagerIntegrationTest.doSetHarvesterDataTest(_metadataRepository, _dataManager, metadataId);
                    }
                });

    }

}
