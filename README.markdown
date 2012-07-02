##Recurse Delete

When you call Record.destroy in Rails, it instantiates all its associations (that are :dependent => :destroy) and calls destroy on each. This is an N + 1, you can delete all the associated records without the N + 1 if you set the association as :dependent => :delete_all. However, this will not delete all the sub associations. This is the compromise recurse-delete solves. You can read more about it here: http://programming-perils.com/436/rails-prevent-dependent-destroy-n-plus-ones/

Add to GemFile: **gem 'recurse-delete'**

Usage: `Record.recurse_delete`