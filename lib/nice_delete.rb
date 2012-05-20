module NiceDelete

  def jd_delete
    assocs = dependent_associations
    to_delete = assocs.reduce([]) { |b,a| b | dependent_association_ids(a) }
    to_delete.each do |h|
      h[:table_name].to_s.classify.constantize.delete_all(:id => h[:ids])
    end
    self.delete
  end

  def dependent_associations
    # Return the names of all associations that are dependent destroy/delete
    delete_assocs = [:delete_all,:delete,:destroy,:destroy_all]
    self.class.reflect_on_all_associations.select do |assoc| 
      delete_assocs.include? assoc.options[:dependent]
    end.map(&:name)
  end

  def dependent_association_ids assoc_name
    # Given an association, return table name and ids for association
    # Also do the same for sub associations 
    dependents = self.send(assoc_name).all
    return [] unless dependents.size > 0
    # get table_name and ids for this association
    table_name = assoc_name.to_s.tableize
    ids = dependents.respond_to?(:map) ? dependents.map(&:id) : [dependents.id]
    ret = [{:table_name => table_name, :ids => ids}]
    # get table_name and ids for all associations of this association
    subs = dependents.first.dependent_associations
    subs.each do |sub|
      sub_ids = sub.to_s.classify.constantize.send("find_all_by_#{table_name.classify.foreign_key}", ids).map(&:id)
      ret.push({:table_name => sub, :ids => sub_ids})
    end
    ret
  end

end

class ActiveRecord::Base
  include NiceDelete
end