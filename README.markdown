== Recurse Delete Example Usage

This is a rails project setup to demonstrate example usage for recurse delete.

Run `rake db:migrate` to setup database. Run `rails c` then call `Parent.first.recurse_delete` to see 4 levels of associations get deleted without any N+1's