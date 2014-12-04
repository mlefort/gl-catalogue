package org.fao.geonet.services.metadata.format.groovy.template;

import com.google.common.annotations.VisibleForTesting;
import com.google.common.base.Optional;
import org.fao.geonet.SystemInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.xml.sax.Attributes;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;

/**
 * Creates fmt-if nodes.
 *
 * @author Jesse on 11/29/2014.
 */
@Component
public class TNodeFactoryIf extends TNodeFactoryByAttName {

    public static final String IF = "if";

    @SuppressWarnings("SpringJavaAutowiringInspection")
    @Autowired
    private SystemInfo info;

    public TNodeFactoryIf(SystemInfo info) {
        super(IF);
        this.info = info;
    }
    public TNodeFactoryIf() {
        super(IF);
    }

    @Override
    public TNode create(String localName, String qName, Attributes attributes) throws IOException {
        final String value = getValue(attributes, IF);
        final FilteredAttributes filteredAttributes = new FilteredAttributes(attributes, IF);
        return new TNodeIf(info, qName, filteredAttributes, value);
    }

    /**
     * An "if" node that renders if the model has a truthy value for the given key.
     * <p/>
     * In this case truthy means, non-null, non-empty (if string, collection, array or map), a number != 0 or true value.
     *
     * If the expression starts with a ! then check is not-ed.
     * <p/>
     * Example:
     * <p/>
     * For the template:
     * <pre><code>
     *     &amp;div fmt-if="key">data&amp;/div>
     * </code></pre>
     * the div will be rendered if there is a value "key" in the model that is a string or Iterable that is non-empty.
     *
     *
     * @author Jesse on 11/29/2014.
     */
    public static class TNodeIf extends TNode {
        public static final double PRECISION = 0.000000001;
        private final String expr;
        private final boolean not;

        public TNodeIf(SystemInfo info, String qName, Attributes attributes, String expr) throws IOException {
            super(info, qName, attributes);
            if (expr.startsWith("!")) {
                this.not = true;
                this.expr = expr.substring(1);
            } else {
                this.not = false;
                this.expr = expr;
            }

        }

        @Override
        protected Optional<String> canRender(TRenderContext context) {
            final Object val = context.getModelValue(this.expr);
            final String truthy = isTruthy(val);
            if (not) {
                return truthy != null ? Optional.<String>absent() :
                        Optional.of("fmt-if=!" + this.expr + " is false (" + this.expr + " is true)");
            } else {
                if (truthy != null) {
                    return Optional.of("fmt-if=" + this.expr + " is " + truthy);
                }
                return Optional.absent();
            }
        }

        @VisibleForTesting
        static String isTruthy(Object val) {
            if (val == null) {
                return "null";
            }
            if (val instanceof String) {
                String sVal = (String) val;
                return sVal.isEmpty() ? "empty" : null;
            } else if (val instanceof Iterable) {
                Iterable itVal = (Iterable) val;
                return itVal.iterator().hasNext() ? null : "empty";
            } else if (val instanceof Enumeration) {
                Enumeration itVal = (Enumeration) val;
                return itVal.hasMoreElements() ? null : "empty";
            } else if (val instanceof Iterator) {
                Iterator itVal = (Iterator) val;
                return itVal.hasNext() ? null : "empty";
            } else if (val instanceof Map) {
                Map mapVal = (Map) val;
                return mapVal.isEmpty() ? "empty" : null;
            } else if (val instanceof Boolean) {
                return (Boolean) val ? null : "false";
            } else if (val instanceof Double) {
                return Math.abs((Double) val) > PRECISION ? null : "0";
            } else if (val instanceof Float) {
                return Math.abs((Float) val) > PRECISION ? null : "0";
            } else if (val instanceof Number) {
                return ((Number)val).intValue() != 0 ? null : "0";
            } else if (val instanceof Character) {
                return  null;
            } else if (val.getClass().isArray()) {
                return ((Object[])val).length > 0 ? null : "empty";
            } else {
                throw new AssertionError("Not a recognized type: " + val.getClass() + ": " + val);
            }
        }
    }
}