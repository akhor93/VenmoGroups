module ApplicationHelper
  def id_to_user(venmoid, friends_arr) 
    friends_arr.each do |f|
      if(f['id'] == venmoid)
        return f
      end
    end
  end

  def num_members(members, addTail = true) 
    if members.length == 1
      if addTail
        return "1 member"
      else
        return "1"
      end
    else
      if addTail
        return members.length.to_s + " members"
      else
        return members.length.to_s
      end
    end
  end
end
