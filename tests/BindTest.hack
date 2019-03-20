use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Bind;
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;
use type Nazg\Glue\ProviderInterface;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class BindTest extends HackTest {

  public function testShouldReturnBindInstance(): void {
    $bind = new Bind(new Container(), BindTypename::class);
    expect($bind)
      ->toBeInstanceOf(Bind::class);
  }

  public function testShouldBeSerializedBind(): void {
    $vec = vec[];
    $container = new Container();
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    expect(\count($container->getBindings()))
      ->toBeSame(1);
  }
}

final class BindTypename {

}
