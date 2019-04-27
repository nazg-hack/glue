use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;
use type Nazg\Glue\DependencyFactory;
use type Nazg\Glue\ProviderInterface;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerTest extends HackTest {

  public function testShoulbReturnPrototypeInstance(): void {
    $container = new Container(new DependencyFactory());
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    \HH\Asio\join($container->lockAsync());
    expect($container->get(Mock::class))
      ->toNotBeSame($container->get(Mock::class));
  }

  public function testShoulbReturnSingletonInstance(): void {
    $container = new Container(new DependencyFactory());
    $container->bind(Mock::class)
      ->to(Mock::class);
    \HH\Asio\join($container->lockAsync());
    expect($container->get(Mock::class))
      ->toBeSame($container->get(Mock::class));
  }

  public function testShoulbThrowNotBindingExceptionAtComplexPrototypeInstance(): void {
    $container = new Container(new DependencyFactory());
    $container->bind(AnyInterface::class)
      ->to(Any::class)
      ->in(Scope::PROTOTYPE);
    \HH\Asio\join($container->lockAsync());
    expect(() ==> $container->get(AnyInterface::class))
      ->toThrow(Exception\NotFoundException::class);
  }

  public function testShoulbReturnComplexPrototypeInstance(): void {
    $container = new Container(new DependencyFactory());
    $container->bind(AnyInterface::class)
      ->to(Any::class)
      ->in(Scope::PROTOTYPE);
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    \HH\Asio\join($container->lockAsync());
    expect($container->get(AnyInterface::class))
      ->toBeInstanceOf(AnyInterface::class);
  }

  public function testShoulbReturnComplexPrototypeInstanceByProvider(): void {
    $container = new Container(new DependencyFactory());
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    $container->bind(Any::class)
      ->provider(new AnyProvider());
    \HH\Asio\join($container->lockAsync());
    expect($container->get(Any::class))
      ->toBeInstanceOf(AnyInterface::class);
  }
}

final class Mock {

}

interface AnyInterface {

}

final class Any implements AnyInterface {
  public function __construct(private Mock $mock) {

  }
}

final class AnyProvider implements ProviderInterface<Any> {

  public function get(\Nazg\Glue\Container $container): Any {
    return new Any($container->get(Mock::class));
  }
}
