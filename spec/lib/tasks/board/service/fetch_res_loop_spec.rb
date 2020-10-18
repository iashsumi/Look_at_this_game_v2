# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tasks::Board::Service, type: :service do
  describe "#fetch_res_loop" do
    context "再帰するデータがある場合" do
      let(:reply) { [
        { no: 2, parent_no: 1, item: { no: 2, text: "aaa" } },
        { no: 3, parent_no: 2, item: { no: 3, text: "bbb" } },
        { no: 4, parent_no: 3, item: { no: 4, text: "ccc" } },
        ]
      }
      let(:input) { { no: 2, parent_no: 1, item: { no: 2, text: "aaa" } } }

      it "順番通りに取得できること" do
        result = Tasks::Board::Service.new.send(:fetch_res_loop, input, reply)
        expect(result).to eq [
          { no: 2, parent_no: 1, item: { no: 2, text: "aaa" } },
          { no: 3, parent_no: 2, item: { no: 3, text: "bbb" } },
          { no: 4, parent_no: 3, item: { no: 4, text: "ccc" } }
        ]
      end
    end

    context "からの場合" do
      it "エラーにならないこと" do
        result = Tasks::Board::Service.new.send(:fetch_res_loop, {}, [])
        expect(result).to eq []
      end
    end
  end
end
