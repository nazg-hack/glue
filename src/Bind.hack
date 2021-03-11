/**
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * This software consists of voluntary contributions made by many individuals
 * and is licensed under the MIT license.
 *
 * Copyright (c) 2018-2019 Yuuki Takezawa
*/

namespace Nazg\Glue;

final class Bind<T> {
  private Scope $scope = Scope::SINGLETON;
  private ?DependencyInterface $bound;

  public function __construct(
    private \Nazg\Glue\Container $container,
    private typename<T> $id,
    private DependencyFactory $factory
  ) {}

  public function to<Tc>(
    typename<Tc> $concrete
  ): this {
    $this->bound = $this->factory->makeInstance($concrete);
    $this->container->add($this);
    return $this;
  }

  public function in(Scope $scope): this {
    $this->scope = $scope;
    $this->container->add($this);
    return $this;
  }

  public function provider<Tp>(
    ProviderInterface<Tp> $provider
  ) : this {
    $this->bound = $this->factory->makeInstanceByProvider($provider);
    $this->container->add($this);
    return $this;
  }

  public function getId()[]: string {
    return $this->id;
  }

  public function getBound()[]: ?DependencyInterface {
    return $this->bound;
  }

  public function getScope()[]: Scope {
    return $this->scope;
  }
}
