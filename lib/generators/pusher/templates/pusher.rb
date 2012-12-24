<% module_namespacing do -%>
class <%= class_name %>Pusher < ActiveModel::Pusher
  events <%= events.map(&:to_sym).map(&:inspect).join(", ") %>
end
<% end -%>