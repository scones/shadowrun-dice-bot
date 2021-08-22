require 'rails_helper'

RSpec.describe Bot::Parser do

  let (:message) { "foo" }
  let (:bot) { described_class.new(message) }
  let (:dice) { double(Dice) }

  before :each do
    allow_any_instance_of(Bot::Commands::Abstract).to receive(:dice).and_return(dice)
  end

  describe '#response' do
    subject (:response) { bot.response }

    context 'WHEN the message IS NOT a command' do
      it { should_not be_empty }
      it { is_expected.to eq Bot::Parser::MISFORMATTED_COMMAND }
    end

    context 'WHEN the message IS a command' do
      context 'WHEN the command IS NOT known' do
        let (:message) { "/some-unknown-command" }

        it { should_not be_empty }
        it { is_expected.to eq Bot::Parser::UNKNOWN_COMMAND }
      end

      context 'WHEN the command IS known' do
        context 'WHEN the command is /help' do
          let (:message) { "/help" }

          it { should_not be_empty }
          it { is_expected.to_not eq Bot::Parser::UNKNOWN_COMMAND }
          it { is_expected.to_not eq Bot::Parser::MISFORMATTED_COMMAND }
        end

        context 'WHEN the command is /sr' do
          context 'WHEN there is no argument' do
            let (:message) { "/sr" }

            context 'WHEN the die rolls a 1' do
              it "SHOULD be a critical glitch" do
                expect(dice).to receive(:roll_6).with(1).and_return([1])

                expect(subject).to eq <<~RESULT
                  /sr 1
                  Roll: 1
                  Hits: 0

                  critical glitch
                RESULT
              end
            end

            context 'WHEN the die rolls a 4' do
              it 'SHOULD be a normal failure' do
                expect(dice).to receive(:roll_6).with(1).and_return([4])

                expect(subject).to eq <<~RESULT
                  /sr 1
                  Roll: 4
                  Hits: 0
                RESULT
              end
            end

            context 'WHEN the die rolls a 5' do
              it 'SHOULD be a normal failure' do
                expect(dice).to receive(:roll_6).with(1).and_return([5])

                expect(subject).to eq <<~RESULT
                  /sr 1
                  Roll: 5
                  Hits: 1
                RESULT
              end
            end
          end

          context 'WHEN there is one argument' do
            let (:dice_count) { 15}
            let (:message) { "/sr #{dice_count}" }

            it 'SHOULD roll the correct amount of dice' do
              expect(dice).to receive(:roll_6).with(dice_count).and_return([2, 3, 5, 2, 6, 5, 5, 5, 3, 5, 5, 2, 1, 5, 4])

              expect(subject).to eq <<~RESULT
                /sr #{dice_count}
                Roll: 2 3 5 2 6 5 5 5 3 5 5 2 1 5 4
                Hits: 8
              RESULT
            end

            context 'WHEN more than half is a 1' do
              it 'SHOULD be a glitch' do
                expect(dice).to receive(:roll_6).with(dice_count).and_return([1, 1, 5, 1, 6, 1, 5, 5, 1, 5, 1, 1, 1, 5, 4])

                expect(subject).to eq <<~RESULT
                  /sr #{dice_count}
                  Roll: 1 1 5 1 6 1 5 5 1 5 1 1 1 5 4
                  Hits: 6

                  glitch
                RESULT
              end
            end
          end

          context 'WHEN there are two arguments' do
            let (:dice_count) { 15}
            let (:threshold) { 4 }
            let (:message) { "/sr #{dice_count} #{threshold}" }

            context 'WHEN it reaches the threshold' do
              context 'WHEN it glitches' do
                it 'SHOULD succeed' do
                  expect(dice).to receive(:roll_6).with(dice_count).and_return([1, 1, 5, 1, 6, 5, 5, 5, 1, 5, 5, 1, 1, 1, 1])

                  expect(subject).to eq <<~RESULT
                    /sr #{dice_count} #{threshold}
                    Roll: 1 1 5 1 6 5 5 5 1 5 5 1 1 1 1
                    Hits: 7

                    success
                    glitch
                  RESULT
                end
              end

              context 'WHEN it does not glitch' do
                it 'SHOULD succeed but glitch' do
                  expect(dice).to receive(:roll_6).with(dice_count).and_return([2, 3, 5, 2, 6, 5, 5, 5, 3, 5, 5, 2, 1, 5, 4])

                  expect(subject).to eq <<~RESULT
                    /sr #{dice_count} #{threshold}
                    Roll: 2 3 5 2 6 5 5 5 3 5 5 2 1 5 4
                    Hits: 8

                    success
                  RESULT
                end
              end
            end

            context 'WHEN it fails the threshold' do
              context 'WHEN it glitches' do
                it 'SHOULD fail and glitch critically' do
                  expect(dice).to receive(:roll_6).with(dice_count).and_return([1, 1, 2, 1, 2, 2, 2, 5, 1, 5, 5, 1, 1, 1, 1])

                  expect(subject).to eq <<~RESULT
                    /sr #{dice_count} #{threshold}
                    Roll: 1 1 2 1 2 2 2 5 1 5 5 1 1 1 1
                    Hits: 3

                    failure
                    critical glitch
                  RESULT
                end
              end

              context 'WHEN it does not glitch' do
                it 'SHOULD fail' do
                  expect(dice).to receive(:roll_6).with(dice_count).and_return([2, 3, 2, 2, 2, 2, 2, 2, 3, 5, 5, 2, 1, 5, 4])

                  expect(subject).to eq <<~RESULT
                    /sr #{dice_count} #{threshold}
                    Roll: 2 3 2 2 2 2 2 2 3 5 5 2 1 5 4
                    Hits: 3

                    failure
                  RESULT
                end
              end
            end
          end
        end

        context 'WHEN the command is /op' do
          context 'WHEN there is no argument' do
            let (:message) { "/op" }

            it { is_expected.to eq Bot::Parser::MISFORMATTED_COMMAND }
          end

          context 'WHEN there is one argument' do
            let (:protagonist_dice_count) { 3 }
            let (:message) { "/op #{protagonist_dice_count}" }

            it { is_expected.to eq Bot::Parser::MISFORMATTED_COMMAND }
          end

          context 'WHEN there are two arguments' do
            let (:protagonist_dice_count) { 10 }
            let (:antagagonist_dice_count) { 10 }
            let (:message) { "/op #{protagonist_dice_count} #{antagagonist_dice_count}" }

            context 'WHEN the protagonist has more hits' do
              it 'SHOULD be successful' do
                expect(dice).to receive(:roll_6).and_return([5, 6, 2, 2, 2, 2, 2, 2, 3, 5], [2, 3, 2, 2, 2, 2, 2, 2, 3, 5])

                expect(subject).to eq <<~RESULT
                  /op #{protagonist_dice_count} #{antagagonist_dice_count}
                  P: 5 6 2 2 2 2 2 2 3 5
                  A: 2 3 2 2 2 2 2 2 3 5
                  Net Hits: 2
                RESULT
              end
            end

            # joghutse
            context 'WHEN the antagonist has more hits' do
              it 'SHOULD be a failure' do
                expect(dice).to receive(:roll_6).and_return([2, 3, 2, 2, 2, 2, 2, 2, 3, 5], [5, 6, 2, 2, 2, 2, 2, 2, 3, 5])

                expect(subject).to eq <<~RESULT
                  /op #{protagonist_dice_count} #{antagagonist_dice_count}
                  P: 2 3 2 2 2 2 2 2 3 5
                  A: 5 6 2 2 2 2 2 2 3 5
                  Net Hits: -2

                  failure
                RESULT
              end
            end
          end
        end
      end
    end
  end
end
