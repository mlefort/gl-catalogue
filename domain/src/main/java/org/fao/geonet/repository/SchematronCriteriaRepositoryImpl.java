package org.fao.geonet.repository;

import org.fao.geonet.domain.SchematronCriteria;
import org.fao.geonet.domain.SchematronCriteriaGroup;
import org.fao.geonet.domain.SchematronCriteriaGroup_;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.Iterator;
import java.util.List;

/**
 * Override behaviour of certain operations.
 *
 * Created by Jesse on 3/7/14.
 */
public class SchematronCriteriaRepositoryImpl {
    @PersistenceContext
    EntityManager _entityManager;

    /**
     * Override method in CRUD repository because criteria need to be removed from Group in order to be deleted.
     *
     * @param id id of criteria to delete
     */
    public void delete(Integer id) {
        SchematronCriteria criteria = _entityManager.getReference(SchematronCriteria.class, id);
        final CriteriaBuilder builder = _entityManager.getCriteriaBuilder();
        final CriteriaQuery<SchematronCriteriaGroup> query = builder.createQuery(SchematronCriteriaGroup.class);
        final Root<SchematronCriteriaGroup> root = query.from(SchematronCriteriaGroup.class);
        final Predicate criteriaIsAMemberOfGroup = builder.isMember(criteria, root.get(SchematronCriteriaGroup_.criteria));
        query.where(criteriaIsAMemberOfGroup);

        List<SchematronCriteriaGroup> groups = _entityManager.createQuery(query).getResultList();

        for (SchematronCriteriaGroup group : groups) {
            Iterator<SchematronCriteria> iterator = group.getCriteria().iterator();
            while (iterator.hasNext()) {
                if (id == iterator.next().getId()) {
                    iterator.remove();
                }
            }
            _entityManager.persist(group);
        }

        _entityManager.flush();

        _entityManager.getEntityManagerFactory().getCache().evict(SchematronCriteria.class);
        _entityManager.getEntityManagerFactory().getCache().evict(SchematronCriteriaGroup.class);
    }
    /**
     * Override method in CRUD repository because criteria need to be removed from Group in order to be deleted.
     *
     * @param criteria criteria to delete
     */
    public void delete(Iterable<SchematronCriteria> criteria) {
        for (SchematronCriteria schematronCriteria : criteria) {
            delete(schematronCriteria.getId());
        }

    }
    /**
     * Override method in CRUD repository because criteria need to be removed from Group in order to be deleted.
     *
     * @param criteria criteria to delete
     */
    public void delete(SchematronCriteria criteria) {
        delete(criteria.getId());
    }
}
