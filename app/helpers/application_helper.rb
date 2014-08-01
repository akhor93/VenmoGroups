module ApplicationHelper
  def id_to_user(venmoid, friends_arr) 
    friends_arr.each do |f|
      if(f['id'] == venmoid)
        return f
      end
    end
  end

  def num_members(members) 
    if members.length == 1
      return "1 member"
    else
      return members.length.to_s + " members"
    end
  end
end
