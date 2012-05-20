module NiceDelete

  def jd_delete
    assocs = dependent_associations
    assocs.map { |a| dependent_association_ids(a) }
  end

  def dependent_associations
    delete_assocs = [:delete_all,:delete,:destroy,:destroy_all]
    self.class.reflect_on_all_associations.select do |assoc| 
      delete_assocs.include? assoc.options[:dependent]
    end.map(&:name)
  end

  def dependent_association_ids assoc_name
    table_name = assoc_name.to_s.pluralize
    dependents = self.send(assoc_name)
    subs = dependents.each { |d| d.dependent_associations }
    puts subs.map(&:jd_delete)
    ids = dependents.respond_to?(:map) ? dependents.map(&:id) : [dependents.id]
    {:table_name => table_name, :ids => ids}
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