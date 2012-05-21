# Recurse Delete by John Isaacks (programming-perils.com)
#
# Copyright (c) 2012 John Isaacks
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module RecurseDelete

  def recurse_delete(model_class=nil, ids=nil)
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
      recurse_delete(sub_model_class, sub_ids)
    end
    
    self
  end

end

class ActiveRecord::Base
  include RecurseDelete
end