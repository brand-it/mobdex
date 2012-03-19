module MassDomainsHelper
  def parse_type_for_select
    [["Space Delemited", 0],["Comma Delemited", 1]]
  end
  
  def parse_type_to_words(parse_type)
    return parse_type_for_select[parse_type][0]
  end
end