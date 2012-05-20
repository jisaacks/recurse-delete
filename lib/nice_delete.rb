module NiceDelete

  def nice_destroy(model_class=nil, ids=nil)
    ids = self.id if ids.nil?
    model_class = self.class if model_class.nil?
    
    # Delete self
    model_class.delete_all(:id => ids)
    
    # find and delete all dependent associations
    delete_assocs = [:delete_all,:delete,:destroy,:destroy_all]
    table_name = model_class.to_s.tableize
    model_class.reflect_on_all_associations.select do |assoc|
      delete_assocs.include? assoc.options[:dependent]
    end.map(&:name).each do |sub|
      sub_model_class = sub.to_s.classify.constantize
      sub_ids = sub_model_class.send("find_all_by_#{table_name.classify.foreign_key}", ids).map(&:id)
      nice_destroy(sub_model_class, sub_ids)
    end
    
    self
  end

end

class ActiveRecord::Base
  include NiceDelete
end