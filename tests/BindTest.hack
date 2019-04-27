use type Nazg\Glue\Bind;
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;
use type Nazg\Glue\DependencyFactory;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class BindTest extends HackTest {

  public function testShouldReturnBindInstance(): void {
    $factory = new DependencyFactory();
    $bind = new Bind(new Container($factory), BindTypename::class, $factory);
    expect($bind)
      ->toBeInstanceOf(Bind::class);
  }

  public function testShouldBeSerializedBind(): void {
    $vec = vec[];
    $container = new Container(new DependencyFactory());
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    \HH\Asio\join($container->lockAsync());
    expect(\count($container->getBindings()))
      ->toBeSame(1);
  }
}

final class BindTypename {

}
