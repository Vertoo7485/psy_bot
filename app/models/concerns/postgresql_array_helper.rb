module PostgresqlArrayHelper
  extend ActiveSupport::Concern
  
  # Методы для работы с PostgreSQL массивами
  module ClassMethods
    # Поиск записей, содержащих все указанные элементы в массиве
    def where_array_contains(column_name, values)
      values = Array(values)
      
      if values.empty?
        where("1 = 0")  # Ничего не возвращаем если массив пустой
      else
        # Используем оператор @> PostgreSQL (содержит все элементы)
        where("#{column_name} @> ARRAY[?]::text[]", values)
      end
    end
    
    # Поиск записей, содержащих любой из указанных элементов
    def where_array_overlaps(column_name, values)
      values = Array(values)
      
      if values.empty?
        where("1 = 0")
      else
        # Используем оператор && PostgreSQL (пересечение массивов)
        where("#{column_name} && ARRAY[?]::text[]", values)
      end
    end
    
    # Поиск записей, где массив имеет определенную длину
    def where_array_length(column_name, length)
      where("array_length(#{column_name}, 1) = ?", length)
    end
    
    # Поиск записей, где массив не пустой
    def where_array_not_empty(column_name)
      where("array_length(#{column_name}, 1) > 0")
    end
  end
  
  # Инстанс-методы
  def array_contains?(column_name, value)
    column_value = send(column_name)
    return false unless column_value.is_a?(Array)
    
    column_value.include?(value)
  end
  
  def array_add(column_name, value)
    column_value = send(column_name) || []
    return false if column_value.include?(value)
    
    new_array = column_value + [value]
    update(column_name => new_array)
  end
  
  def array_remove(column_name, value)
    column_value = send(column_name) || []
    return false unless column_value.include?(value)
    
    new_array = column_value - [value]
    update(column_name => new_array)
  end
end