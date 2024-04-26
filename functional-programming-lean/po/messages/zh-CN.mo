Þ    *      l  ;   ¼      ¨  û  ©  ^   ¥      ,    ò   J	    =
  c   W  Ü   »  :        Ó  N  ì  ·   ;  	   ó  ²   ý     °    ¿    O  7   ^  h     L  ÿ  .   L    {  É     Ï   N  2    Ê  Q  B     ¬   _  ?    \   L  B   ©  l   ì  8   Y   a      {   ô   w   p!  .   è!  *   "  '   B"     j"      w"    "  ·  ©#  Y   a%    »%    U'  Ö   s(    J)  o   Í+  ¦   =,  +   ä,     -  
  $-     /.     Á.  ª   Ê.     u/    /  ÿ   1  .   2  R   Í2     3  (   ?4  Ô   h4  ¯   =5  À   í5  
  ®6  i  ¹7  B   #9  ¬   f9  @  :  Ã  T;  B   ?  l   [?  7   È?  a    @  g   b@  h   Ê@  0   3A  *   dA  3   A  	   ÃA     ÍA                   !   "      %                 
                           #   *                  (                   &          $       )            	                                      '                   A `lakefile.lean` describes a _package_, which is a coherent collection of Lean code for distribution, analogous to an `npm` or `nuget` package or a Rust crate. A package may contain any number of libraries or executables. While the [documentation for Lake](https://github.com/leanprover/lean4/blob/master/src/lake/README.md) describes the available options in a lakefile, it makes use of a number of Lean features that have not yet been described here. The generated `lakefile.lean` contains the following: An `IO` action `main` is executed when the program starts. `main` can have one of three types: As described in [this chapter's introduction](../monads.md#numbering-tree-nodes), `State Ï Î±` represents programs that make use of a mutable variable of type `Ï` and return a value of type `Î±`. These programs are actually functions from a starting state to a pair of a value and a final state. The `Monad` class requires that its parameter expect a single type argumentâthat is, it should be a `Type â Type`. This means that the instance for `State` should mention the state type `Ï`, which becomes a parameter to the instance: Because evidence for an "and" is a constructor, it can be used with pattern matching. For instance, a proof that _A_ and _B_ implies _A_ or _B_ is a function that pulls the evidence of _A_ (or of _B_) out of the evidence for _A_ and _B_, and then uses this evidence to produce evidence of _A_ or _B_: Because many different types are monads, functions that are polymorphic over _any_ monad are very powerful. For example, the function `mapM` is a version of `map` that uses a `Monad` to sequence and combine the results of applying a function: Each Lakefile will contain exactly one package, but any number of libraries or executables. Additionally, Lakefiles may contain _external libraries_, which are libraries not written in Lean to be statically linked with the resulting executable, _custom targets_, which are build targets that don't fit naturally into the library/executable taxonomy, _dependencies_, which are declarations of other Lean packages (either locally or from remote Git repositories), and _scripts_, which are essentially `IO` actions (similar to `main`), but that additionally have access to metadata about the package configuration. The items in the Lakefile allow things like source file locations, module hierarchies, and compiler flags to be configured. Generally speaking, however, the defaults are reasonable. Each of these names is enclosed in guillemets to allow users more freedom in picking package names. Extend `feline` with support for usage information. The extended version should accept a command-line argument `--help` that causes documentation about the available command-line options to be written to standard output. Finally, the `-` argument should be handled appropriately. General Monad Operations Implication (if _A_ then _B_) is represented using functions. In particular, a function that transforms evidence for _A_ into evidence for _B_ is itself evidence that _A_ implies _B_. This is different from the usual description of implication, in which `A â B` is shorthand for `Â¬A â¨ B`, but the two formulations are equivalent. In the standard library, Lean calls this function `List.length`, which means that the dot syntax that is used for structure field access can also be used to find the length of a list: Lakefiles Many of the functions in `feline` exhibit a repetitive pattern in which an `IO` action's result is given a name, and then used immediately and only once. For instance, in `dump`: Nested Actions Side effects are aspects of program execution that go beyond the evaluation of mathematical expressions, such as reading files, throwing exceptions, or triggering industrial machinery. While most languages allow side effects to occur during evaluation, Lean does not. Instead, Lean has a type called `IO` that represents _descriptions_ of programs that use side effects. These descriptions are then executed by the language's run-time system, which invokes the Lean expression evaluator to carry out specific computations. Values of type `IO Î±` are called _`IO` actions_. The simplest is `pure`, which returns its argument and has no actual side effects. Similarly, "`A` or `B`" (written `A â¨ B`) has two constructors, because a proof of "`A` or `B`" requires only that one of the two underlying propositions be true. There are two constructors: `Or.inl`, with type `A â A â¨ B`, and `Or.inr`, with type `B â A â¨ B`. Similarly, `fileStream` contains the following snippet: The fact that `m` must have a `Monad` instance means that the `>>=` and `pure` operations are available. The return type of the function argument `f` determines which `Monad` instance will be used. In other words, `mapM` can be used for functions that produce logs, for functions that can fail, or for functions that use mutable state. Because `f`'s type determines the available effects, they can be tightly controlled by API designers. This initial Lakefile consists of three items: This means that the type of the state cannot change between calls to `get` and `set` that are sequenced using `bind`, which is a reasonable rule for stateful computations. The operator `increment` increases a saved state by a given amount, returning the old value: This version of `dump` avoids introducing names that are used only once, which can greatly simplify a program. `IO` actions that Lean lifts from a nested expression context are called _nested actions_. To build the package, run the command `lake build`. After a number of build commands scroll by, the resulting binary has been placed in `build/bin`. Running `./build/bin/greeting` results in `Hello, world!`. When Lean is compiling a `do` block, expressions that consist of a left arrow immediately under parentheses are lifted to the nearest enclosing `do`, and their results are bound to a unique name. This unique name replaces the origin of the expression. This means that `dump` can also be written as follows: `IO` actions can also be understood as functions that take the whole world as an argument and return a new world in which the side effect has occurred. Behind the scenes, the `IO` library ensures that the world is never duplicated, created, or destroyed. While this model of side effects cannot actually be implemented, as the whole universe is too big to fit in memory, the real world can be represented by a token that is passed around through the program. ```
echo "and purr" | ./build/bin/feline test1.txt - test2.txt
``` ```lean
def andThen (first : State Ï Î±) (next : Î± â State Ï Î²) : State Ï Î² :=
  fun s =>
    let (s', x) := first s
    next x s'

infixl:55 " ~~> " => andThen
``` ```lean
def fileStream (filename : System.FilePath) : IO (Option IO.FS.Stream) := do
  if not (â filename.pathExists) then
    (â IO.getStderr).putStrLn s!"File not found: {filename}"
    pure none
  else
    let handle â IO.FS.Handle.mk filename IO.FS.Mode.read
    pure (some (IO.FS.Stream.ofHandle handle))
``` ```leantac
theorem addAndAppend : 1 + 1 = 2 â§ "Str".append "ing" = "String" := by simp
``` ```output info
Except.error "Index 2 not found (maximum is 1)"
``` ```output info
Except.ok ("Peregrine falcon", "Golden eagle", "Spur-winged goose", "Anna's hummingbird")
``` `fileStream` can be simplified using the same technique: `main : IO UInt32` is used for programs without arguments that may signal success or failure, and `main : IO Unit` is used for simple programs that cannot read their command-line arguments and always return exit code `0`, `main : List String â IO UInt32` is used for programs that take command-line arguments and signal success or failure. a _library_ declaration, named `Greeting`, and a _package_ declaration, named `greeting`, an _executable_, also named `greeting`. should yield the pattern occurs for `stdout`: Project-Id-Version: Functional Programming in Lean
PO-Revision-Date: 
Last-Translator: 
Language-Team: 
Language: zh_CN
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
X-Generator: Poedit 3.4.2
 `lakefile.lean` æè¿°äºä¸ä¸ª _å_ï¼å®æ¯ä¸ä¸ªè¿è´¯ç Lean ä»£ç éåï¼ç¨äºååï¼ç±»ä¼¼äº `npm` æ `nuget` åæ Rust ç®±å­ãä¸ä¸ªåå¯ä»¥åå«ä»»ææ°éçåºæå¯æ§è¡æä»¶ãè½ç¶ [Lake ææ¡£](https://github.com/leanprover/lean4/blob/master/src/lake/README.md) æè¿°äº lakefile ä¸­çå¯ç¨éé¡¹ï¼ä½å®ä½¿ç¨äºæ­¤å¤å°æªæè¿°çè®¸å¤ Lean ç¹æ§ãçæç `lakefile.lean` åå«ä»¥ä¸åå®¹ï¼ å½ç¨åºå¯å¨æ¶ï¼å°æ§è¡ `IO` æä½ `main`ã`main` å¯ä»¥æä¸ç§ç±»åä¹ä¸ï¼ å¦ [æ¬ç« ç®ä»](../monads.md#numbering-tree-nodes) æè¿°ï¼`State Ï Î±` è¡¨ç¤ºä½¿ç¨ç±»åä¸º `Ï` çå¯ååéå¹¶è¿åç±»åä¸º `Î±` çå¼çç¨åºãè¿äºç¨åºå®éä¸æ¯ä»èµ·å§ç¶æå°å¼åæç»ç¶æå¯¹çå½æ°ã`Monad` ç±»è¦æ±å¶åæ°ææåä¸ªç±»ååæ°ï¼å³å®åºè¯¥æ¯ `Type â Type`ãè¿æå³ç `State` çå®ä¾åºæåç¶æç±»å `Ï`ï¼å®æä¸ºå®ä¾çåæ°ï¼ å ä¸ºâä¸âçè¯æ®æ¯ä¸ä¸ªæé å¨ï¼æä»¥å®å¯ä»¥ä¸æ¨¡å¼å¹éä¸èµ·ä½¿ç¨ãä¾å¦ï¼è¯æ _A_ å _B_ è´æ¶µ _A_ æ _B_ çè¯ææ¯ä¸ä¸ªå½æ°ï¼å®ä» _A_ å _B_ çè¯æ®ä¸­æå _A_ï¼æ _B_ï¼çè¯æ®ï¼ç¶åä½¿ç¨æ­¤è¯æ®æ¥çæ _A_ æ _B_ çè¯æ®ï¼ ç±äºè®¸å¤ä¸åç±»åé½æ¯ monadï¼å æ­¤å¨ _ä»»ä½_ monad ä¸å¤æçå½æ°éå¸¸å¼ºå¤§ãä¾å¦ï¼å½æ° `mapM` æ¯ `map` çä¸ä¸ªçæ¬ï¼å®ä½¿ç¨ `Monad` å¯¹åºç¨å½æ°çç»æè¿è¡æåºåç»åï¼ æ¯ä¸ª Lakefile å°åªåå«ä¸ä¸ªåï¼ä½å¯ä»¥åå«ä»»ææ°éçåºæå¯æ§è¡æä»¶ãæ­¤å¤ï¼Lakefile å¯è½åå« _å¤é¨åº_ï¼ä¸æ¯ç¨ Lean ç¼åçåºï¼å°ä¸ç»æå¯æ§è¡æä»¶éæé¾æ¥ï¼ã_èªå®ä¹ç®æ _ï¼ä¸èªç¶å°éåäºåº/å¯æ§è¡æä»¶åç±»çæå»ºç®æ ï¼ã_ä¾èµé¡¹_ï¼å¶ä» Lean åçå£°æï¼å¨æ¬å°ææ¥èªè¿ç¨ Git å­å¨åºï¼ï¼ãä»¥å _èæ¬_ï¼æ¬è´¨ä¸æ¯ `IO` æä½ï¼ç±»ä¼¼äº `main`ï¼ï¼ä½è¿å¯ä»¥è®¿é®æå³åéç½®çåæ°æ®ï¼ãLakefile ä¸­çé¡¹åè®¸éç½®æºæä»¶ä½ç½®ãæ¨¡åå±æ¬¡ç»æåç¼è¯å¨æ å¿ãç¶èï¼ä¸è¬æ¥è¯´ï¼é»è®¤å¼æ¯åççã è¿äºåç§°ä¸­çæ¯ä¸ä¸ªé½ç¨å¼å·æ¬èµ·æ¥ï¼ä»¥åè®¸ç¨æ·å¨éæ©ååç§°æ¶ææ´å¤§çèªç±åº¦ã æ©å± `feline` ä»¥æ¯æä½¿ç¨ä¿¡æ¯ãæ©å±çæ¬åºæ¥åå½ä»¤è¡åæ° `--help`ï¼è¯¥åæ°ä¼å¯¼è´æå³å¯ç¨å½ä»¤è¡éé¡¹çææ¡£è¢«åå¥æ åè¾åºã æç»ï¼`-` åæ°åºå¾å°éå½å¤çã éç¨ Monad æä½ è´æ¶µï¼å¦æ _A_ å _B_ï¼ä½¿ç¨å½æ°è¡¨ç¤ºãç¹å«æ¯ï¼å° _A_ çè¯æ®è½¬æ¢ä¸º _B_ çè¯æ®çå½æ°æ¬èº«å°±æ¯ _A_ è´æ¶µ _B_ çè¯æ®ãè¿ä¸è´æ¶µçéå¸¸æè¿°ä¸åï¼å¶ä¸­ `A â B` æ¯ `Â¬A â¨ B` çç®åï¼ä½è¿ä¸¤ä¸ªå¬å¼æ¯ç­ä»·çã å¨æ ååºä¸­ï¼Lean å°æ­¤å½æ°ç§°ä¸º `List.length`ï¼è¿æå³çç¨äºç»æå­æ®µè®¿é®çç¹è¯­æ³ä¹å¯ä»¥ç¨äºæ¥æ¾åè¡¨çé¿åº¦ï¼ Lakefile `feline` ä¸­çè®¸å¤å½æ°é½è¡¨ç°åºä¸ç§éå¤æ¨¡å¼ï¼å¶ä¸­ `IO` æä½çç»æè¢«èµäºä¸ä¸ªåç§°ï¼ç¶åç«å³ä¸ä»ä½¿ç¨ä¸æ¬¡ãä¾å¦ï¼å¨ `dump` ä¸­ï¼ åµå¥æä½ å¯ä½ç¨æ¯ç¨åºæ§è¡ä¸­è¶åºæ°å­¦è¡¨è¾¾å¼æ±å¼èå´çé¨åï¼ä¾å¦è¯»åæä»¶ãæåºå¼å¸¸æè§¦åå·¥ä¸æºæ¢°ãè½ç¶å¤§å¤æ°è¯­è¨åè®¸å¨æ±å¼æé´åçå¯ä½ç¨ï¼ä½ Lean ä¸ä¼ãç¸åï¼Lean æä¸ä¸ªåä¸º `IO` çç±»åï¼å®è¡¨ç¤ºä½¿ç¨å¯ä½ç¨çç¨åºç _æè¿°_ãç¶åç±è¯­è¨çè¿è¡æ¶ç³»ç»æ§è¡è¿äºæè¿°ï¼è¯¥ç³»ç»è°ç¨ Lean è¡¨è¾¾å¼æ±å¼å¨æ¥æ§è¡ç¹å®è®¡ç®ãç±»åä¸º `IO Î±` çå¼ç§°ä¸º _`IO` æä½_ãæç®åçæ¯ `pure`ï¼å®è¿åå¶åæ°å¹¶ä¸æ²¡æå®éå¯ä½ç¨ã ç±»ä¼¼å°ï¼â`A` æ `B`âï¼åä¸º `A â¨ B`ï¼æä¸¤ä¸ªæé å¨ï¼å ä¸ºâ`A` æ `B`âçè¯æä»è¦æ±ä¸¤ä¸ªåºå±å½é¢ä¸­çä¸ä¸ªä¸ºçãæä¸¤ä¸ªæé å¨ï¼`Or.inl`ï¼ç±»åä¸º `A â A â¨ B`ï¼å `Or.inr`ï¼ç±»åä¸º `B â A â¨ B`ã åæ ·ï¼`fileStream` åå«ä»¥ä¸ä»£ç æ®µï¼ `m` å¿é¡»æ `Monad` å®ä¾ï¼è¿æå³çå¯ä»¥ä½¿ç¨ `>>=` å `pure` æä½ã å½æ°åæ° `f` çè¿åç±»åå³å®äºå°ä½¿ç¨åªä¸ª `Monad` å®ä¾ãæ¢å¥è¯è¯´ï¼`mapM` å¯ç¨äºçææ¥å¿çå½æ°ãå¯è½å¤±è´¥çå½æ°æä½¿ç¨å¯åç¶æçå½æ°ãç±äº `f` çç±»åå³å®äºå¯ç¨çææï¼å æ­¤ API è®¾è®¡äººåå¯ä»¥å¯¹å¶è¿è¡ä¸¥æ ¼æ§å¶ã è¿ä¸ªåå§ Lakefile ç±ä¸é¡¹ç»æï¼ è¿æå³çå¨ä½¿ç¨ `bind` å¯¹ `get` å `set` è¿è¡æåºæ¶ï¼ç¶æçç±»åä¸è½æ´æ¹ï¼è¿æ¯æç¶æè®¡ç®çåçè§åãè¿ç®ç¬¦ `increment` å°ä¿å­çç¶æå¢å ç»å®éï¼å¹¶è¿åæ§å¼ï¼ æ­¤çæ¬ç `dump` é¿åäºå¼å¥ä»ä½¿ç¨ä¸æ¬¡çåç§°ï¼è¿å¯ä»¥æå¤§å°ç®åç¨åºãLean ä»åµå¥è¡¨è¾¾å¼ä¸ä¸æä¸­æåç `IO` æä½ç§°ä¸º _åµå¥æä½_ã è¦æå»ºåï¼è¿è¡å½ä»¤ `lake build`ãå¨æ»å¨æ¾ç¤ºä¸äºæå»ºå½ä»¤åï¼ç»æäºè¿å¶æä»¶å·²æ¾ç½®å¨ `build/bin` ä¸­ãè¿è¡ `./build/bin/greeting` ä¼çæ `Hello, world!`ã å½ Lean ç¼è¯ `do` åæ¶ï¼ç±æ¬å·ä¸æ¹çå·¦ç®­å¤´ç»æçè¡¨è¾¾å¼ä¼è¢«æåå°æè¿çå°é­ `do` ä¸­ï¼å¹¶ä¸å¶ç»æä¼è¢«ç»å®å°ä¸ä¸ªå¯ä¸åç§°ãè¿ä¸ªå¯ä¸åç§°æ¿æ¢äºè¡¨è¾¾å¼çæ¥æºãè¿æå³ç `dump` ä¹å¯ä»¥åæå¦ä¸å½¢å¼ï¼ `IO` æä½è¿å¯ä»¥çè§£ä¸ºå°æ´ä¸ªä¸çä½ä¸ºåæ°å¹¶è¿åä¸ä¸ªå¯ä½ç¨å·²ç»åççå¨æ°ä¸ççå½æ°ãå¨å¹åï¼`IO` åºç¡®ä¿ä¸çæ°¸è¿ä¸ä¼è¢«å¤å¶ãåå»ºæéæ¯ãè½ç¶è¿ç§å¯ä½ç¨æ¨¡åå®éä¸æ æ³å®ç°ï¼å ä¸ºæ´ä¸ªå®å®å¤ªå¤§èæ æ³æ¾å¥åå­ï¼ä½ç°å®ä¸çå¯ä»¥ç¨ä¸ä¸ªå¨ç¨åºä¸­ä¼ éçä»¤çæ¥è¡¨ç¤ºã ```
echo "and purr" | ./build/bin/feline test1.txt - test2.txt
``` ```lean
def andThen (first : State Ï Î±) (next : Î± â State Ï Î²) : State Ï Î² :=
  fun s =>
    let (s', x) := first s
    next x s'

infixl:55 " ~~> " => andThen
``` ```lean
def fileStream (filename : System.FilePath) : IO (Option IO.FS.Stream) := do
  if not (â filename.pathExists) then
    (â IO.getStderr).putStrLn s!"æä»¶æªæ¾å°: {filename}"
    pure none
  else
    let handle â IO.FS.Handle.mk filename IO.FS.Mode.read
    pure (some (IO.FS.Stream.ofHandle handle))
``` å®ç addAndAppend : 1 + 1 = 2 â§ "Str".append "ing" = "String" := by simp





ï¼

è¿æ¥è¯ | Lean è¯­æ³ | è¯æ®
---|---|---
ç | `True` | `True.intro : True`
å | `False` | æ è¯æ®
_A_ å _B_ | `A â§ B` | `And.intro : A â B â A â§ B`
_A_ æ _B_ | `A â¨ B` | `Or.inl : A â A â¨ B` æ `Or.inr : B â A â¨ B`
_A_ è´æ¶µ _B_ | `A â B` | å° _A_ çè¯æ®è½¬æ¢ä¸º _B_ çè¯æ®çå½æ°
é _A_ | `Â¬A` | å° _A_ çè¯æ®è½¬æ¢ä¸º `False` çè¯æ®çå½æ°

`simp` ææ¯å¯ä»¥è¯æä½¿ç¨è¿äºè¿æ¥è¯çå®çãä¾å¦ï¼

è¯æ®ä½ä¸ºåæ°

è½ç¶ `simp` å¨è¯ææ¶åç¹å®æ°å­çç¸ç­æ§åä¸ç­æ§çå½é¢æ¹é¢åå¾å¾å¥½ï¼ä½å®å¨è¯ææ¶ååéçéè¿°æ¹é¢å¹¶ä¸æ¯å¾å¥½ãä¾å¦ï¼`simp` å¯ä»¥è¯æ `4 < 15`ï¼ä½å®ä¸è½è½»æå°è¯´æå ä¸º `x < 4`ï¼æä»¥ `x < 15` ä¹æ¯ççãå ä¸ºç´¢å¼è¡¨ç¤ºå¨å¹åä½¿ç¨ `simp` æ¥è¯ææ°ç»è®¿é®æ¯å®å¨çï¼æä»¥å®å¯è½éè¦ä¸äºäººå·¥å¹²é¢ã ```output info
Except.error "Index 2 not found (maximum is 1)"
``` ```output info
Except.ok ("Peregrine falcon", "Golden eagle", "Spur-winged goose", "Anna's hummingbird")
``` `fileStream` å¯ä»¥ä½¿ç¨ç¸åçææ¯è¿è¡ç®åï¼ `main : IO UInt32` ç¨äºæ²¡æåæ°çç¨åºï¼è¯¥ç¨åºå¯è½ä¼ååºæåæå¤±è´¥ä¿¡å·ï¼ `main : IO Unit` ç¨äºæ æ³è¯»åå¶å½ä»¤è¡åæ°ä¸å§ç»è¿åéåºä»£ç  `0` çç®åç¨åºï¼ `main : List String â IO UInt32` ç¨äºè·åå½ä»¤è¡åæ°å¹¶ååºæåæå¤±è´¥ä¿¡å·çç¨åºã ä¸ä¸ªåä¸º `Greeting` ç _åº_å£°æï¼ä»¥å ä¸ä¸ªåä¸º `greeting` ç _å_å£°æï¼ ä¸ä¸ªä¹åä¸º `greeting` ç _å¯æ§è¡æä»¶_ã åºäº§ç æ¨¡å¼åçå¨ `stdout` ä¸­ï¼ 