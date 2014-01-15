shared_examples 'a converter' do
  it { should respond_to(:call).with(1).argument }
end
