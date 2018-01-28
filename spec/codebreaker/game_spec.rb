require 'spec_helper'

module Codebreaker
  RSpec.describe Codebreaker::Game do
    SECRET_CODE_SIZE = 4

    context '#guess' do
      before { subject.instance_variable_set(:@secret_arr, [1, 2, 3, 4]) }

      it { expect(subject.guess('aaaaaa')).to be_falsey }
      it { expect(subject.guess('1234')).to eq '++++' }
      it { expect(subject.guess('4321')).to eq '----' }

      it 'decreases attempts quantity' do
        SECRET_CODE_SIZE.times { subject.guess('1111') }
        attempts_quantity = subject.instance_variable_get(:@attempts_quantity)
        expect(attempts_quantity).to eq 6
      end

      it 'count work' do
        SECRET_CODE_SIZE.times { subject.guess('1111') }
        count = subject.instance_variable_get(:@count)
        expect(count).to eq SECRET_CODE_SIZE
      end
    end

    context '#str_to_arr' do
      let(:player_arr) { subject.str_to_arr('1234') }

      it 'get array from player string' do
        expect(player_arr).to eq [1, 2, 3, 4]
      end

      it 'array have SECRET_CODE_SIZE items count' do
        expect(player_arr.size).to eq SECRET_CODE_SIZE
      end
    end

    context '#generate_code!' do
      let(:secret_code) { subject.instance_variable_get(:@secret_arr) }

      it 'get secret code' do
        expect(:@secret_arr).not_to be_empty
      end

      it 'secret code have 4 items' do
        expect(secret_code.size).to eq SECRET_CODE_SIZE
      end

      it 'secret code with numbers from 1 to 6' do
        expect(secret_code.to_s).to match(/[1-6]+/)
      end
    end

    context '#compare_of_value' do
      before { subject.instance_variable_set(:@secret_arr, [1, 2, 3, 4]) }

      it 'received empty string' do
        result_str = subject.compare_of_value([5, 5, 5, 5])
        expect(result_str).to eq ''
      end

      it 'received string result "+"' do
        result_str = subject.compare_of_value([5, 5, 5, 4])
        expect(result_str).to eq '+'
      end

      it 'received string result "++"' do
        result_str = subject.compare_of_value([5, 5, 3, 4])
        expect(result_str).to eq '++'
      end

      it 'received string result "+++"' do
        result_str = subject.compare_of_value([5, 2, 3, 4])
        expect(result_str).to eq '+++'
      end

      it 'received string result "++++"' do
        result_str = subject.compare_of_value([1, 2, 3, 4])
        expect(result_str).to eq '++++'
      end

      it 'received string result "++--"' do
        result_str = subject.compare_of_value([2, 1, 3, 4])
        expect(result_str).to eq '++--'
      end

      it 'received string result "+---"' do
        result_str = subject.compare_of_value([3, 1, 2, 4])
        expect(result_str).to eq '+---'
      end

      it 'received string result "----"' do
        result_str = subject.compare_of_value([4, 3, 2, 1])
        expect(result_str).to eq '----'
      end

      it 'received string result "---"' do
        result_str = subject.compare_of_value([4, 3, 2, 5])
        expect(result_str).to eq '---'
      end

      it 'received string result "--"' do
        result_str = subject.compare_of_value([4, 3, 5, 5])
        expect(result_str).to eq '--'
      end

      it 'received string result "-"' do
        result_str = subject.compare_of_value([4, 5, 5, 5])
        expect(result_str).to eq '-'
      end
    end

    context '#check_hint' do
      let(:hint_quantity) { subject.instance_variable_get(:@hint_quantity) }

      it 'player have 1 hint ' do
        expect(hint_quantity).to eq 1
      end

      it 'return 0 if player has been used "hint"' do
        subject.check_hint
        expect(hint_quantity).to eq 0
      end

      it 'return false if hint quantity eq 0' do
        subject.instance_variable_set(:@hint_quantity, 0)
        expect(subject.check_hint).to be_falsey
      end
    end

    context '#victory?' do
      before { subject.instance_variable_set(:@secret_arr, [1, 2, 3, 4]) }

      it 'return true if player_arr eq secret_arr' do
        subject.instance_variable_set(:@player_arr, [1, 2, 3, 4])
        expect(subject.victory?).to be_truthy
      end

      it 'return false if player_arr not eq secret_arr' do
        subject.instance_variable_set(:@player_arr, [1, 1, 1, 1])
        expect(subject.victory?).to be_falsey
      end
    end

    context '#lose?' do
      it 'return true if attempts count eq 0' do
        subject.instance_variable_set(:@attempts_quantity, 0)
        expect(subject.lose?).to be_truthy
      end

      it 'return false if attempts count eq 5' do
        subject.instance_variable_set(:@attempts_quantity, 5)
        expect(subject.lose?).to be_falsey
      end
    end

    context '#valid_data?' do
      it 'return true if player input eq array and size = 4' do
        subject.instance_variable_set(:@player_arr, [1, 1, 1, 1])
        expect(subject.valid_data?).to be_truthy
      end

      it 'return false if player input eq array and size = 3' do
        subject.instance_variable_set(:@player_arr, [1, 1, 1])
        expect(subject.valid_data?).to be_falsey
      end

      it 'return false if player input eq string and size = 4' do
        subject.instance_variable_set(:@player_arr, 'aaaa')
        expect(subject.valid_data?).to be_falsey
      end
    end

    context '#save_result' do
      it 'exist file if save result' do
        subject.save_result(:@player_name, :@count, :@player_arr)
        expect(File.exist?('@player_name_file.txt')).to be_truthy
      end

      it 'not exist file if save result' do
        subject.save_result(:@player_name, :@count, :@player_arr)
        expect(File.exist?('@player_name')).to be_falsey
      end
    end
  end
end
