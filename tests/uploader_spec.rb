require 'rspec'
require_relative '../bin/uploader'

describe 'read file' do

  before do
    uploader = Uploader.new
  end

  it 'should parse the csv' do
    uploader = Uploader.new
    expect(uploader.get_first_line('../uploads/course_sample.csv')).to eq %w(course_id course_name state)
    expect(uploader.get_first_line('../uploads/student_sample.csv')).to eq %w(user_id user_name course_id state)
  end

  it 'should identify which table it is' do
    uploader = Uploader.new
    expect(uploader.student_or_course(%w(course_id course_name state))).to eq :course
    expect(uploader.student_or_course(%w(course_name course_id state))).to eq :course
    expect(uploader.student_or_course(%w(course_name state course_id))).to eq :course
  end

  it 'should write to the course table' do
    uploader = Uploader.new
    uploader.write_to_table '../uploads/course_sample.csv'
  end

  it 'should write to the student table' do
    uploader = Uploader.new
    uploader.write_to_table '../uploads/student_sample.csv'
  end
end