# common functors

abstract Functor{N}  # N is the number of arguments

typealias UnaryFunctor Functor{1}
typealias BinaryFunctor Functor{2}
typealias TernaryFunctor Functor{3}

####################################### 
#
#  Macros to define functors
#
####################################### 

macro functor1(F, T, f)
    quote
        global evaluate
        type $F <: Functor{1} end
        evaluate(::($F), x::($T)) = ($f)(x)
    end
end

macro functor2(F, T, f)
    quote
        global evaluate
        type $F <: Functor{2} end
        evaluate(::($F), x::($T), y::($T)) = ($f)(x, y)
    end
end

macro functor3(F, T, f)
    quote
        global evaluate
        type $F <: Functor{3} end
        evaluate(::($F), x::($T), y::($T), z::($T)) = ($f)(x, y, z)
    end
end


####################################### 
#
#  Functors for operators
#
####################################### 

export 
    Negate, Add, Subtract, Multiply, Divide, Pow, Modulo,
    Greater, GreaterEqual, Less, LessEqual, Equal, NotEqual,
    Not, And, Or,
    BitwiseNot, BitwiseAnd, BitwiseOr, BitwiseXor

# arithmetic operators

type Negate <: Functor{1} end
evaluate(::Negate, x::Number) = -x

type Add <: Functor{2} end
evaluate(::Add, x::Number, y::Number) = x + y

type Subtract <: Functor{2} end
evaluate(::Subtract, x::Number, y::Number) = x - y

type Multiply <: Functor{2} end
evaluate(::Multiply, x::Number, y::Number) = x * y

type Divide <: Functor{2} end
evaluate(::Divide, x::Number, y::Number) = x / y

type Pow <: Functor{2} end
evaluate(::Pow, x::Number, y::Number) = x ^ y

type Modulo <: Functor{2} end
evaluate(::Modulo, x::Real, y::Real) = x % y

# comparison operators

type Greater <: Functor{2} end
evaluate(::Greater, x::Real, y::Real) = x > y

type GreaterEqual <: Functor{2} end
evaluate(::GreaterEqual, x::Real, y::Real) = x >= y

type Less <: Functor{2} end
evaluate(::Less, x::Real, y::Real) = x < y

type LessEqual <: Functor{2} end
evaluate(::LessEqual, x::Real, y::Real) = x <= y

type Equal <: Functor{2} end
evaluate(::Equal, x::Number, y::Number) = x == y

type NotEqual <: Functor{2} end
evaluate(::NotEqual, x::Number, y::Number) = x != y

# logical operators

type Not <: Functor{1} end
evaluate(::Not, x::Bool) = !x

type And <: Functor{2} end 
evaluate(::And, x::Bool, y::Bool) = (x && y)

type Or <: Functor{2} end
evaluate(::Or, x::Bool, y::Bool) = (x || y)

type BitwiseNot <: Functor{1} end
evaluate(::BitwiseNot, x::Real) = (~x)

type BitwiseAnd <: Functor{2} end
evaluate(::BitwiseAnd, x::Real, y::Real) = (x & y)

type BitwiseOr <: Functor{2} end
evaluate(::BitwiseOr, x::Real, y::Real) = (x | y)

type BitwiseXor <: Functor{2} end
evaluate(::BitwiseXor, x::Real, y::Real) = (x $ y)


####################################### 
#
#  Functors for elementary math
#
####################################### 

export 
    MaxFun, MinFun,
    AbsFun, Abs2Fun, SqrFun, RcpFun, SqrtFun, RsqrtFun,
    CbrtFun, RcbrtFun, HypotFun, FixPow, FixAbsPow,
    IsfiniteFun, IsinfFun, IsnanFun, IsequalFun,
    FloorFun, CeilFun, RoundFun, TruncFun,
    IfloorFun, IceilFun, IroundFun, ItruncFun,
    ModFun, FldFun, RemFun, DivFun, 
    ExpFun, Exp2Fun, Exp10Fun, Expm1Fun, 
    LogFun, Log2Fun, Log10Fun, Log1pFun, LdexpFun,
    SinFun, CosFun, TanFun, CotFun, SecFun, CscFun,
    SindFun, CosdFun, TandFun, CotdFun, SecdFun, CscdFun,
    SinhFun, CoshFun, TanhFun, CothFun, SechFun, CschFun,
    AsinFun, AcosFun, AtanFun, AcotFun, AsecFun, AcscFun,
    AsindFun, AcosdFun, AtandFun, AcotdFun, AsecdFun, AcscdFun,
    AsinhFun, AcoshFun, AtanhFun, AcothFun, AsechFun, AcschFun,
    Atan2Fun

# basic functors

@functor2 MaxFun Real max
@functor2 MinFun Real min

type _Max <: Functor{2} end
evaluate(::_Max, x::Real, y::Real) = ifelse(y > x, y, x)

type NonnegMax <: Functor{2} end
evaluate(::NonnegMax, x::Real, y::Real) = ifelse(y > x, y, x)

type _Min <: Functor{2} end
evaluate(::_Min, x::Real, y::Real) = ifelse(y < x, y, x)

# absolute value & power

@functor1 AbsFun   Number abs
@functor1 Abs2Fun  Number abs2
@functor1 SqrFun   Number sqr
@functor1 RcpFun   Number rcp
@functor1 SqrtFun  Number sqrt
@functor1 RsqrtFun Number rsqrt
@functor1 CbrtFun  Real   cbrt
@functor1 RcbrtFun Real   rcbrt
@functor2 HypotFun Real   hypot

immutable FixPow{T<:Real} <: Functor{1}
    p::T
end
evaluate(f::FixPow, x::Real) = (x ^ f.p)

immutable FixAbsPow{T<:Real} <: Functor{1}
    p::T
end
evaluate(f::FixAbsPow, x::Real) = (abs(x) ^ f.p)

# number classifying functors

@functor1 IsfiniteFun Real   isfinite
@functor1 IsnanFun    Real   isnan
@functor1 IsinfFun    Real   isinf
@functor2 IsequalFun  Number isequal

# rounding functors

@functor1 FloorFun Real floor
@functor1 CeilFun  Real ceil
@functor1 RoundFun Real round
@functor1 TruncFun Real trunc

@functor1 IfloorFun Real ifloor
@functor1 IceilFun  Real iceil
@functor1 IroundFun Real iround
@functor1 ItruncFun Real itrunc

# division & modulus functors

@functor2 ModFun Real mod
@functor2 FldFun Real fld
@functor2 RemFun Real rem
@functor2 DivFun Real div

# exponentiation & logarithm

@functor1 ExpFun   Number exp
@functor1 Exp2Fun  Number exp2
@functor1 Exp10Fun Number exp10

@functor1 LogFun   Number log
@functor1 Log2Fun  Number log2
@functor1 Log10Fun Number log10

@functor1 Expm1Fun Real expm1
@functor1 Log1pFun Real log1p

type LdexpFun <: Functor{2} end
evaluate(::LdexpFun, x::Real, n::Integer) = ldexp(x, n)

# trigonometric & hyperbolic

@functor1 SinFun Number sin
@functor1 CosFun Number cos
@functor1 TanFun Number tan
@functor1 CotFun Number cot
@functor1 SecFun Number sec
@functor1 CscFun Number csc

@functor1 SindFun Real sind
@functor1 CosdFun Real cosd
@functor1 TandFun Real tand
@functor1 CotdFun Real cotd
@functor1 SecdFun Real secd
@functor1 CscdFun Real cscd

@functor1 SinhFun Number sinh
@functor1 CoshFun Number cosh
@functor1 TanhFun Number tanh
@functor1 CothFun Number coth
@functor1 SechFun Number sech
@functor1 CschFun Number csch

@functor1 AsinFun Number asin
@functor1 AcosFun Number acos
@functor1 AtanFun Number atan
@functor1 AcotFun Number acot
@functor1 AsecFun Number asec
@functor1 AcscFun Number acsc

@functor1 AsindFun Real asind
@functor1 AcosdFun Real acosd
@functor1 AtandFun Real atand
@functor1 AcotdFun Real acotd
@functor1 AsecdFun Real asecd
@functor1 AcscdFun Real acscd

@functor1 AsinhFun Number asinh
@functor1 AcoshFun Number acosh
@functor1 AtanhFun Number atanh
@functor1 AcothFun Number acoth
@functor1 AsechFun Number asech
@functor1 AcschFun Number acsch

@functor2 Atan2Fun Real atan2


####################################### 
#
#  Functors for special functions
#
####################################### 

export ErfFun, ErfcFun, ErfInvFun, ErfcInvFun,
    GammaFun, LgammaFun, LfactFun, DigammaFun,
    BetaFun, LbetaFun, ZetaFun,
    AiryFun, AiryprimeFun, AiryaiFun, AiryaiprimeFun,
    AirybiFun, AirybiprimeFun,
    BesseljFun, Besselj0Fun, Besselj1Fun, BesseliFun, BesselkFun,
    LogitFun, LogisticFun, InvLogisticFun,
    XlogxFun, XlogyFun

# error functors

@functor1 ErfFun     Real erf
@functor1 ErfcFun    Real erfc
@functor1 ErfInvFun  Real erfinv
@functor1 ErfcInvFun Real erfcinv

# gamma functors

@functor1 GammaFun   Real gamma
@functor1 LgammaFun  Real lgamma
@functor1 LfactFun   Real lfact
@functor1 DigammaFun Real digamma

# beta functors

@functor2 BetaFun  Real beta
@functor2 LbetaFun Real lbeta
@functor1 EtaFun   Real eta
@functor1 ZetaFun  Real zeta

# airy functors

@functor1 AiryFun        Real airy
@functor1 AiryprimeFun   Real airyprime
@functor1 AiryaiFun      Real airyai
@functor1 AiryaiprimeFun Real airyaiprime
@functor1 AirybiFun      Real airybi
@functor1 AirybiprimeFun Real airybiprime

# bessel functors

@functor2 BesseljFun  Real besselj
@functor1 Besselj0Fun Real besselj0
@functor1 Besselj1Fun Real besselj1
@functor2 BesseliFun  Real besseli
@functor2 BesselkFun  Real besselk

# stats-related functors

@functor1 LogitFun       Real logit
@functor1 LogisticFun    Real logistic
@functor1 InvLogisticFun Real invlogistic

@functor1 XlogxFun Real xlogx
@functor2 XlogyFun Real xlogy



####################################### 
#
#  Ternary functors
#
####################################### 

export FMA, IfelseFun

type FMA <: Functor{3} end
evaluate(::FMA, x::Number, y::Number, z::Number) = (x + y * z)

type IfelseFun <: Functor{3} end
evaluate{T<:Number}(::IfelseFun, c::Bool, x::T, y::T) = ifelse(c, x, y)


####################################### 
#
#  type inference facility
#
####################################### 

fptype{T<:FloatingPoint}(::Type{T}) = T
fptype{T<:Integer}(::Type{T}) = Float64
fptype{T<:Union(Bool,Uint8,Int8,Uint16,Int16)}(::Type{T}) = Float32

typealias BasicBinaryFuns Union(Add,Subtract,Multiply,MaxFun,MinFun,_Max,_Min,NonnegMax)

result_type{T}(f::BasicBinaryFuns, ::Type{T}, ::Type{T}) = promote_type(T)
result_type{T1,T2}(f::BasicBinaryFuns, ::Type{T1}, ::Type{T2}) = promote_type(T1, T2)

result_type(f::Functor{1}, t1::Type) = typeof(evaluate(f, one(t1)))
result_type(f::Functor{2}, t1::Type, t2::Type) = typeof(evaluate(f, one(t1), one(t2)))
result_type(f::Functor{3}, t1::Type, t2::Type, t3::Type) = typeof(evaluate(f, one(t1), one(t2), one(t3)))

typealias BlasFP Union(Float32,Float64)

