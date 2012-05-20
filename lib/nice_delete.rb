module NiceDelete

  def jd_delete
    assocs = dependent_associations
    to_delete = assocs.reduce([]) { |b,a| b | dependent_association_ids(a) }
    to_delete.each do |h|
      #puts "#{h}"
      h[:table_name].to_s.classify.constantize.delete_all(:id => h[:ids])
    end
    self.delete
  end

  def dependent_associations
    delete_assocs = [:delete_all,:delete,:destroy,:destroy_all]
    self.class.reflect_on_all_associations.select do |assoc| 
      delete_assocs.include? assoc.options[:dependent]
    end.map(&:name)
  end

  def dependent_association_ids assoc_name
    table_name = assoc_name.to_s.pluralize
    dependents = self.send(assoc_name).all
    return [] unless dependents.size > 0
    subs = dependents.first.dependent_associations
    #puts table_name.foreign_key
    #sub_ids = subs.map { |s| dependent_association_ids(s) } 
    #subs = dependents.each{ |d| d.dependent_associations }
    #puts subs.map(&:jd_delete)
    #puts subs
    ids = dependents.respond_to?(:map) ? dependents.map(&:id) : [dependents.id]

    ret = [{:table_name => table_name, :ids => ids}]

    subs.each do |sub|
      sub_ids = sub.to_s.classify.constantize.send("find_all_by_#{table_name.classify.foreign_key}", ids).map(&:id)
      ret.push({:table_name => sub, :ids => sub_ids})
    end
    #{:table_name => table_name, :ids => ids}
    #dependents.first.class.find(ids)
    ret
  end

  # def dependent_associations
  #   delete_assocs = [:delete_all,:delete,:destroy,:destroy_all]
  #   # Self.reflect_on_all_associations.select do |assoc| 
  #   #   delete_assocs.include? assoc.options[:dependent]
  #   # end.map(&:name)

  #   self.class.reflect_on_all_associations.select do |assoc| 
  #     delete_assocs.include? assoc.options[:dependent]
  #   end.map do |assoc|
  #     table_name = assoc.name.to_s.pluralize
  #     dependents = self.send(assoc.name)
  #     subs = dependents.each { |d| d.dependent_associations }
  #     puts subs
  #     ids = dependents.respond_to?(:map) ? dependents.map(&:id) : [dependents.id]
  #     {:table_name => table_name, :ids => ids}
  #   end
  # end

  def subdependent_associations parent_name, child_name, ids

  end

end

class ActiveRecord::Base
  include NiceDelete
end