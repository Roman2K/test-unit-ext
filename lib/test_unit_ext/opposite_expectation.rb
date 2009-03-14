module TestUnitExt::OppositeExpectation
  # Usage example:
  #
  #   host = Host.new
  #   expects_chain(host, 'portage.install').returns :success
  #   
  #   host.portage.install  # => :success
  #
  def expects_chain(obj, chain)
    stub_chain_for_object_with(:expects, :mock, obj, chain)
  end
  
  # Usage example:
  #
  #   host = Host.new
  #   stubs_chain(host, 'portage.installed?').returns false
  #   
  #   host.portage.installed?   # => false
  #
  def stubs_chain(obj, chain)
    stub_chain_for_object_with(:stubs, :stub, obj, chain)
  end
  
  # Usage example:
  #
  #   host = Host.new
  #   expects_chain_never(host, 'portage.uninstall')
  #   
  #   host.portage.uninstall  # does nothing
  #
  def expects_chain_never(obj, chain)
    chain = parse_chain! chain
    obj.expects(chain.first.to_sym).never
  end
  
private

  def stub_chain_for_object_with(method, receiver_builder, obj, chain)
    chain = parse_chain! chain
    expectation, receiver = nil, obj
    loop do
      expectation = receiver.send(method, chain.shift.to_sym)
      break if chain.empty?
      expectation.returns(receiver = send(receiver_builder))
    end
    return expectation
  end
  
  def parse_chain!(chain)
    chain = chain.to_s.split('.')
    raise ArgumentError, "empty call chain" if chain.empty?
    return chain
  end
end
