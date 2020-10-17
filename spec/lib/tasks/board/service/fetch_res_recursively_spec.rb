# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tasks::Board::Service, type: :service do
  describe "#fetch_res_recursively" do
    context "再帰するデータがある場合" do
      let(:reply) { [
        { res_no: 1, item: { no: 2, text: "aaa" } },
        { res_no: 2, item: { no: 3, text: "bbb" } },
        { res_no: 3, item: { no: 4, text: "ccc" } },
        ]
      }
      let(:input) { [
        { res_no: 1, item: { no: 2, text: "aaa" } },
        { res_no: 1, item: { no: 7, text: "ddd" } }
        ]
      }

      it "順番通りに取得できること" do
        result = Tasks::Board::Service.new.send(:fetch_res_recursively, input, reply)
        expect(result).to eq [
          { res_no: 1, item: { no: 2, text: "aaa" } },
          { res_no: 2, item: { no: 3, text: "bbb" } },
          { res_no: 3, item: { no: 4, text: "ccc" } },
          { res_no: 1, item: { no: 7, text: "ddd" } }
        ]
      end
    end

    context "からの場合" do
      it "エラーにならないこと" do
        result = Tasks::Board::Service.new.send(:fetch_res_recursively, [], [])
        expect(result).to eq []
      end
    end
  end
end
