require 'byebug'

class DiffParams
  attr_reader :diff_params

  def initialize(params_list1, params_list2)
    @params_list1 = params_list1
    @params_list2 = params_list2
    @diff_params = []

    compare_params_lists
  end

  private

  def compare_params_lists
    new_params_names,
    removed_params_names,
    unchanged_params_names = items_diff(@params_list1, @params_list2)

    @diff_params << label_items(@params_list2, new_params_names, 1)
    @diff_params << label_items(@params_list1, removed_params_names, -1)

    unchanged_params_names.each do |params_name|
      @diff = { name: params_name, :methods=> [] }
      @params1 = find_item(@params_list1, params_name)
      @params2 = find_item(@params_list2, params_name)

      compare

      @diff[:name] = [@diff[:name], 0]
      @diff_params << @diff
    end
    remove_empty_params
  end

  def label_params(params, label)
    params[:name] = [params[:name], label]
  end

  def compare
    new_methods_names,
    removed_methods_names,
    unchanged_methods_names = items_diff(@params1[:methods], @params2[:methods])

    new_methods = label_items(@params2[:methods], new_methods_names, 1)
    removed_methods = label_items(@params1[:methods], removed_methods_names, -1)

    @diff[:methods] << new_methods
    @diff[:methods] << removed_methods
    process_unchanged_methods(unchanged_methods_names)

    remove_empty_methods
    @diff[:methods].flatten!
  end

  # returns hash with method2 params and diff (e.g. args2 - args1)
  def compare_methods(method1, method2)
    args_diff = method2[:args] - method1[:args]
    length_diff = method2[:length] - method1[:length]
    conditions_diff = method2[:conditions] - method1[:conditions]
    { name: [method1[:name], 0],
      args: [method2[:args], args_diff],
      length: [method2[:length], length_diff],
      conditions: [method2[:conditions], conditions_diff] }
  end

  def items_diff(items1, items2)
    items_names1 = items_names(items1)
    items_names2 = items_names(items2)

    new_items = items_names2 - items_names1
    removed_items = items_names1 - items_names2
    unchanged_items = items_names2 - new_items

    [new_items, removed_items, unchanged_items]
  end

  def items_names(items)
    items.map { |item| item[:name] }
  end

  def find_item(items, name)
    item = items.select { |item| item[:name] == name }
    item.first unless item.nil?
  end

  # 0 - unchanged, -1 - removed, 1 - new
  def label_item(items, item_name, label)
    item = find_item(items, item_name)
    item[:name] = [item[:name], label]
    item
  end

  def label_items(items, items_names, label)
    items_names.map { |item_name| label_item(items, item_name, label) }
  end

  def process_unchanged_methods(unchanged_methods_names)
    unchanged_methods_names.each do |method_name|
      method1 = find_item(@params1[:methods], method_name)
      method2 = find_item(@params2[:methods], method_name)
      @diff[:methods] << compare_methods(method1, method2)
    end

    unchanged_methods = label_items(@params1[:methods], unchanged_methods_names, 0)
  end

  def remove_empty_methods
    @diff[:methods].select! { |item| item != [] }
  end

  def remove_empty_params
    @diff_params.select! { |item| item != [] }
  end
end
