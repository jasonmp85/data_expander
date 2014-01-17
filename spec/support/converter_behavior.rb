shared_examples 'a converter' do
  it { should respond_to(:convert).with(1).argument }
end
