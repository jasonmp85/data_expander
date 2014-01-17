shared_examples 'a generator of' do |*types|
  OBSERVATIONS = {
    float:    [-2.0, -1.0, 0.0, 1.0, 2.0],
    integer:  [0, 1, 2, 3],
    string: %w[a b c d],
    time:     0.step(by: 86_400).take(4).map { |s| Time.at(s) }
  }.freeze

  it { should respond_to(:observe).with(1).argument }
  it { should respond_to(:generate).with(0).arguments }

  OBSERVATIONS.each do |type, observations|
    if types.include? type
      context "created with type: #{type}" do
        subject { described_class.new(type: type) }
        let(:ruby_type) { DataExpander::Generators::SUPPORTED_TYPES[type] }

        its(:generate) { should be_kind_of(ruby_type) }

        context 'after several observations' do
          before { observations.each { |o| subject.observe(o) } }

          it 'should generate seeded values' do
            values = 3.times.map { subject.generate }

            values.each { |v| v.should be_kind_of(ruby_type) }
          end
        end
      end
    else
      it("can not generate #{type} values") do
        expect { described_class.new(type: type) }
          .to raise_error(ArgumentError)
      end
    end
  end
end
