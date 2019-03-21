use type ReflectionClass;
use type Nazg\Glue\Injector;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class InjectorTest extends HackTest {

  public function testShouldReturnReflectionTuple(): void {
    $injector = new Injector(new ReflectionClass(InjectableStubClassForTest::class));
    list($reflection, $v) = $injector->getReflectionClass();
    expect($reflection)
      ->toBeInstanceOf(ReflectionClass::class);
    expect($v)->toBeNull();
  }

  public function testShouldReturnReflectionTupleAtVec(): void {
    $injector = new Injector(
      new ReflectionClass(
        InjectableStubClassForTestWithConstructorParameters::class
      )
    );
    list($_, $v) = $injector->getReflectionClass();
    expect($v)->toInclude(vec['InjectableStubClassForTest', 'HH\string']);
  }
}

class InjectableStubClassForTest {

}

class InjectableStubClassForTestWithConstructorParameters {
  public function __construct(
    private InjectableStubClassForTest $stub,
    private string $message
  ) {}
}
