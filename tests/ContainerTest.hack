use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerTest extends HackTest {

  public function testHasIdentifierShoulbReturnBool(): void {
    $container = new Container();
    $container->bind(Mock::class)
      ->to(Scope::PROTOTYPE, Mock::class);
    // $container->get(Mock::class);
    $container->lock();
    var_dump($container->get(Mock::class));
  }
}

final class Mock {

}
