local System = System
local throw = System.throw
local Int = System.Int
local ArgumentNullException = System.ArgumentNullException
local ArgumentException = System.ArgumentException

local pairs = pairs
local tostring = tostring

local Enum = {}

Enum.compareTo = Int.compareTo
Enum.equalsObj = Int.equalsObj
Enum.getHashCode = Int.getHashCode
Enum.__defaultVal__ = 0

function Enum.toString(this, cls)
    for k, v in pairs(cls) do
        if v == this then
           return k
        end
    end
    return tostring(this)
end

local function tryParseEnum(enumType, value, ignoreCase)
    if enumType == nil then 
        throw(ArgumentNullException("enumType"))
    end
    if not enumType:getIsEnum() then
        throw(ArgumentException("Arg_MustBeEnum"))
    end
    if value == nil then
        return
    end
    value = System.String.trim(value)
    if #value == 0 then
        return
    end
    if ignoreCase then
        value = value:lower()
    end
    for k, v in pairs(enumType.c) do
        if ignoreCase then
           k = k:lower()
        end
        if k == value then
            return v
        end
    end
end

function Enum.parse(enumType, value, ignoreCase)
   local result = tryParseEnum(enumType, value, ignoreCase)
   if result == nil then
       throw(ArgumentException("parse enum fail: ".. value))
   end
   return result
end

function Enum.tryParse(TEnum, value, result, ignoreCase)
    result = tryParseEnum(System.typeof(TEnum), value, ignoreCase)
    if result == nil then
        return false, 0
    end
    return true, result
end

System.define("System.Enum", Enum);



